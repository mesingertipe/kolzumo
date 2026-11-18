import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/controllers/thermal_printer_controller.dart';
import 'package:kolzumo_app/core/services/telemetry_service.dart';
import 'package:kolzumo_app/data/database/daos/ventas_dao.dart';
import 'package:kolzumo_app/data/database/database.dart';
import 'package:kolzumo_app/infrastructure/models/invoice.dart';
import 'package:kolzumo_app/logic/auth_logic.dart';
import 'package:kolzumo_app/presentation/screens/screen_home.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/success_sale_dialog_widget.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/ticket_preview_dialog.dart';
import 'package:kolzumo_app/providers/cart_provider.dart';
import 'package:kolzumo_app/providers/checkout_provider.dart';
import 'package:kolzumo_app/providers/inventario_provider.dart';
import 'package:kolzumo_app/providers/precio_provider.dart';
import 'package:kolzumo_app/services/storage_service.dart';
import 'package:kolzumo_app/services/vendedor_service.dart';
import 'package:provider/provider.dart';

import '../../../infrastructure/formatters/currency_formatter.dart';

class CheckoutSummary extends StatefulWidget {
  const CheckoutSummary({
    super.key,
    required this.subtotal,
    required this.descuento,
    required this.iva,
  });

  final double subtotal;
  final double descuento;
  final double iva;

  @override
  State<CheckoutSummary> createState() => _CheckoutSummaryState();
}

class _CheckoutSummaryState extends State<CheckoutSummary> {
  bool _isConfirming = false;

  Future<void> _confirmSale() async {
    final database = context.read<AppDatabase>();
    final checkout = context.read<CheckoutProvider>();
    final cart = context.read<CartProvider>();
    final printer = context.read<ThermalPrinterController>();
    final user = context.read<Auth>().userAccount;
    final inventario = context.read<InventarioProvider>();
    final precio = context.read<PreciosProvider>();

    if (!printer.canOperate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.dangerColor,
          content: const Text(
            'Debe conectar una impresora Bluetooth o activar Modo Impresora Virtual antes de registrar la venta.',
          ),
          action: SnackBarAction(
            label: 'Configurar',
            textColor: Colors.white,
            onPressed: () => Navigator.of(context).pushNamed('/printers'),
          ),
        ),
      );
      return;
    }

    if (!checkout.puedeFinalizar) {
      showDialog(
        context: context,
        builder: (_) => VentaFinalizadaDialog(
          exitosa: false,
          motivo: checkout.motivoNoVenta,
          totalVenta: 0,
          totalPagado: 0,
          saldoPendiente: 0,
          cantidadProductos: 0,
          pagos: const [],
        ),
      );
      return;
    }

    setState(() => _isConfirming = true);

    try {
      final total = widget.subtotal - widget.descuento;
      final totalPagado = checkout.totalPagado;
      final saldoPendiente = checkout.saldoPendiente;
      final items = cart.items.entries.toList();
      final cantidadItems = items.fold<int>(0, (s, e) => s + e.value);

      final storage = StorageService();
      final vendedorService = VendedorService();

      // 1. Obtiene el consecutivo y el prefijo real del vendedor (Cero Hardcoding)
      final consecutivoDB = await database.ventasDao.getConsecutivoDB();
      var format = await storage.getConsecutivoFormat(user!.idvendedor);
      int consecutivo = 1;

      if (consecutivoDB != null) {
        consecutivo = consecutivoDB + 1;
      } else {
        try {
          final consecutivoServ =
              await vendedorService.getConsecutivo(user.idvendedor);
          final parsed = consecutivoServ.parseConsecutivo();
          consecutivo = parsed.number;
          format = (prefix: parsed.prefix, padWidth: parsed.padWidth);
          await storage.saveConsecutivoFormat(
            idVendedor: user.idvendedor,
            prefix: parsed.prefix,
            padWidth: parsed.padWidth,
          );
        } catch (_) {
          consecutivo = 1;
        }
      }

      final String consecutivoStr =
          '${format.prefix}${consecutivo.toString().padLeft(format.padWidth, '0')}';

      final List<InvoiceItem> invoiceItems = items.map((entry) {
        final producto = inventario.getById(entry.key);
        final precioItem = precio.getByIds(
              entry.key,
              checkout.cliente!.idcategoriaCliente,
            ) ??
            producto?.precio;

        return InvoiceItem(
          productName: producto?.nombreproducto ?? 'Producto #${entry.key}',
          unitPrice: precioItem?.valor ?? 0,
          quantity: entry.value,
        );
      }).toList();

      final invoiceVenta = Invoice(
        date: DateTime.now(),
        storeName: checkout.cliente!.nombreestablecimiento,
        customerName: checkout.cliente!.administrador,
        customerTaxId: checkout.cliente!.documento,
        customerAddress: checkout.cliente!.direccion,
        sellerName: user.nombre,
        items: invoiceItems,
        summary: InvoiceSummary(
          subtotal: widget.subtotal,
          discount: widget.descuento,
          tax: widget.iva,
          totalPaid: totalPagado,
        ),
        payments: checkout.pagos,
        debtToDate: saldoPendiente > 0 ? saldoPendiente : 0,
      );

      // 2. Imprime el recibo en la impresora Bluetooth y genera la tirilla digital
      final ticketText =
          await printer.printInvoice(invoiceVenta, consecutivoStr);

      // 3. Registra la venta en SQLite local (Drift)
      await database.ventasDao.registrarVenta(
        clienteId: checkout.cliente!.idcliente,
        vendedorId: user.idvendedor,
        consecutivo: consecutivo,
        rutaId: checkout.cliente!.idruta,
        lineas: items.map((e) {
          final producto = inventario.getById(e.key);
          final precioItem = precio.getByIds(
                e.key,
                checkout.cliente!.idcategoriaCliente,
              ) ??
              producto?.precio;

          return LineaVentaInput(
            productoId: e.key,
            cantidad: e.value,
            precioUnitario: precioItem?.valor ?? 0,
            porcentajeIva: producto?.porcentajeiva ?? 0,
          );
        }).toList(),
        pagos: checkout.pagos.map((e) {
          return PagoVentaInput(
            formaPagoId: e.metodoPago.idformapago,
            monto: e.valor,
          );
        }).toList(),
      );

      // 4. Descuenta las existencias en SQLite local
      await database.catalogosDao.descontarCantidadesVendidas(items);

      await TelemetryService.instance.logEvent('sale_completed', {
        'consecutivo': consecutivoStr,
        'total_venta': total,
        'total_pagado': totalPagado,
        'saldo_credito': saldoPendiente > 0 ? saldoPendiente : 0,
      });

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => VentaFinalizadaDialog(
          exitosa: true,
          consecutivo: consecutivoStr,
          totalVenta: total,
          totalPagado: totalPagado,
          saldoPendiente: saldoPendiente > 0 ? saldoPendiente : 0,
          cantidadProductos: cantidadItems,
          pagos: checkout.pagos,
          onVerTirilla: () {
            showTicketPreviewDialog(
              context,
              ticketText: ticketText,
              title: 'Recibo Pedido #$consecutivoStr',
              onReprint: () =>
                  printer.printInvoice(invoiceVenta, consecutivoStr),
            );
          },
          onImprimir: () => printer.printInvoice(invoiceVenta, consecutivoStr),
          onNuevaVenta: () {
            context.read<CheckoutProvider>().reset();
            cart.clear();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (_) => const HomeApp(initialTab: 1),
              ),
              (route) => false,
            );
          },
        ),
      );
    } finally {
      if (mounted) setState(() => _isConfirming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkout = context.watch<CheckoutProvider>();
    final total = widget.subtotal - widget.descuento;
    final totalPagado = checkout.totalPagado;
    final saldoPendiente = checkout.saldoPendiente;
    final cambio = checkout.cambio;

    checkout.total = total;

    return Material(
      elevation: 12,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            boxShadow: const [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black12,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _row('Subtotal', CurrencyFormatter.toCOP(widget.subtotal)),
              if (widget.descuento > 0) ...[
                const SizedBox(height: 4),
                _row(
                  'Descuentos',
                  '- ${CurrencyFormatter.toCOP(widget.descuento)}',
                  color: AppTheme.primaryColor,
                ),
              ],
              if (widget.iva > 0) ...[
                const SizedBox(height: 4),
                _row('IVA', CurrencyFormatter.toCOP(widget.iva)),
              ],
              const Divider(height: 18),
              _row(
                'TOTAL A PAGAR',
                CurrencyFormatter.toCOP(total),
                bold: true,
              ),
              const SizedBox(height: 6),
              _row(
                'Medios de pago hoy',
                CurrencyFormatter.toCOP(totalPagado),
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 4),
              saldoPendiente < 0
                  ? _row(
                      'Cambio a devolver',
                      CurrencyFormatter.toCOP(cambio),
                      color: AppTheme.infoBlue,
                      bold: true,
                    )
                  : _row(
                      checkout.clienteTieneCredito
                          ? 'Saldo a crédito'
                          : 'Faltante por pagar',
                      CurrencyFormatter.toCOP(saldoPendiente),
                      color: saldoPendiente > 0
                          ? (checkout.clienteTieneCredito
                              ? AppTheme.orangeBadge
                              : AppTheme.dangerColor)
                          : AppTheme.primaryColor,
                    ),
              if (checkout.clienteTieneCredito &&
                  checkout.cliente?.cupo != null) ...[
                const SizedBox(height: 4),
                _row(
                  'Cupo disponible',
                  CurrencyFormatter.toCOP(checkout.cliente!.cupo.toString()),
                ),
              ],
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  icon: _isConfirming
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.print_rounded),
                  label: Text(
                    _isConfirming
                        ? 'Registrando e imprimiendo...'
                        : 'Registrar Venta e Imprimir',
                  ),
                  onPressed: _isConfirming ? null : _confirmSale,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(
    String title,
    String value, {
    bool bold = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: bold ? 15 : 13.5,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            fontSize: bold ? 18 : 14.5,
          ),
        ),
      ],
    );
  }
}
