import 'package:flutter/material.dart';
import 'package:kolzumo_app/controllers/thermal_printer_controller.dart';
import 'package:kolzumo_app/data/database/daos/ventas_dao.dart';
import 'package:kolzumo_app/data/database/database.dart';
import 'package:kolzumo_app/infrastructure/models/invoice.dart';
import 'package:kolzumo_app/logic/auth_logic.dart';
import 'package:kolzumo_app/presentation/screens/screen_customer.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/success_sale_dialog_widget.dart';
import 'package:kolzumo_app/providers/cart_provider.dart';
import 'package:kolzumo_app/providers/checkout_provider.dart';
import 'package:kolzumo_app/providers/inventario_provider.dart';
import 'package:kolzumo_app/providers/precio_provider.dart';
import 'package:kolzumo_app/services/vendedor_service.dart';
import 'package:provider/provider.dart';

import '../../../infrastructure/formatters/currency_formatter.dart';

class CheckoutSummary extends StatelessWidget {

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
  Widget build(BuildContext context) {

    // * Providers
    final database = context.read<AppDatabase>();
    final checkout = context.watch<CheckoutProvider>();
    final cart = context.watch<CartProvider>();
    final printer = context.watch<ThermalPrinterController>();
    final user = context.watch<Auth>().userAccount;
    final inventario = context.watch<InventarioProvider>();
    final precio = context.watch<PreciosProvider>();

    // * Service
    VendedorService vendedorService = VendedorService();

    // * Variables 
    final total = subtotal - descuento;
    final totalPagado = checkout.totalPagado;
    final saldoPendiente = checkout.saldoPendiente;
    final cambio = checkout.cambio;

    final items = cart.items.entries.toList();
    final cantidadItems = items.length;

    checkout.total = total;

    int consecutivo = 0;
    

    return Material(

      elevation: 12,

      child: SafeArea(

        child: Container(
          padding: const EdgeInsets.all(16),
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
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outlineVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),

              _row(
                "Subtotal",
                CurrencyFormatter.toCOP(subtotal),
              ),

              const SizedBox(height:8),

              
              _row(
                "Descuentos",
                descuento != 0 ? "- ${CurrencyFormatter.toCOP(descuento)}" : CurrencyFormatter.toCOP(descuento),
                color: descuento != 0 ? Colors.green : null,
              ),

              const SizedBox(height:8),

              _row(
                "IVA",
                CurrencyFormatter.toCOP(iva),
              ),

              const Divider(height:30),

              _row(
                "TOTAL",
                CurrencyFormatter.toCOP(total),
                bold: true,
              ),

              if(totalPagado > 0) ...[

                _row(
                  "Total Pagado",
                  CurrencyFormatter.toCOP(totalPagado),
                ),

                saldoPendiente < 0
                ? _row(
                    "Cambio",
                    CurrencyFormatter.toCOP(cambio),
                  )
                : _row(
                    "Saldo Pendiente",
                    CurrencyFormatter.toCOP(saldoPendiente),
                  ),
              ],

              if(checkout.cliente!.credito == 'Si')
                _row(
                  "Cupo Disponible",
                  CurrencyFormatter.toCOP(checkout.cliente!.cupo.toString()),
                ),
              
              const SizedBox(height:20),

              SizedBox(

                width: double.infinity,

                height: 50,

                child: FilledButton.icon(

                  icon: const Icon(Icons.payment),

                  label: const Text("Confirmar venta",),

                  onPressed: () async {
                    if (checkout.puedeFinalizar) {

                      // * Obtiene consecutivo
                      final consecutivoDB = await database.ventasDao.getConsecutivoDB();
                      
                      if (consecutivoDB != null) {
                        consecutivo = consecutivoDB + 1;
                      } else {
                        final consecutivoServ = await vendedorService.getConsecutivo(user!.idvendedor);
                        consecutivo = int.parse(consecutivoServ.consecutivoremision.substring(3));
                      }

                      // * Creación consecutivo
                      final consecutivoStr = 'VPP-${consecutivo.toString().padLeft(4, '0')}';

                      final List<InvoiceItem> invoiceItems = items.map((entry) {
                        final producto = inventario.getById(entry.key);
                        final precioItem = precio.getByIds(entry.key, checkout.cliente!.idcategoriaCliente);

                        return InvoiceItem(
                          productName: producto!.nombreproducto,
                          unitPrice: precioItem!.valor,
                          quantity: entry.value, 
                        );
                      }).toList();

                      final invoiceVenta = Invoice(
                        date: DateTime.now(), 
                        storeName: checkout.cliente!.nombreestablecimiento, 
                        customerName: checkout.cliente!.administrador, 
                        customerTaxId: checkout.cliente!.documento, 
                        customerAddress: checkout.cliente!.direccion, 
                        sellerName: user!.nombre, 
                        items: invoiceItems, 
                        summary: InvoiceSummary(subtotal: total, totalPaid: totalPagado),
                        payments: checkout.pagos
                      );

                      // * Print
                      //await printer.printInvoice(invoiceVenta, consecutivoStr);
                      
                      //* Registrar venta 
                      database.ventasDao.registrarVenta(
                        clienteId: checkout.cliente!.idcliente, 
                        vendedorId: user.idvendedor, 
                        consecutivo: consecutivo,
                        rutaId: checkout.cliente!.idruta,
                        lineas: items.map((e) {
                          final producto = inventario.getById(e.key);

                          return LineaVentaInput(
                            productoId: e.key, 
                            cantidad: e.value, 
                            precioUnitario: producto!.precio!.valor, 
                            porcentajeIva: producto.porcentajeiva
                          );
                        }).toList(),
                        pagos: checkout.pagos.map((e) {

                          return PagoVentaInput(
                            formaPagoId: e.metodoPago.idformapago, 
                            monto: e.valor
                          );
                        }).toList(),
                      );

                      // * Actualización tabla BD
                      await database.catalogosDao.descontarCantidadesVendidas(items);

                      if(!context.mounted) return;

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => VentaFinalizadaDialog(
                          exitosa: true,
                          consecutivo: consecutivoStr,
                          totalVenta: checkout.total,
                          totalPagado: checkout.totalPagado,
                          saldoPendiente: checkout.saldoPendiente,
                          cantidadProductos: cantidadItems,
                          pagos: checkout.pagos,

                          onNuevaVenta: () {

                            // * Vacia metodo pado, tipo pago, pagos y carrito
                            context.read<CheckoutProvider>().reset();
                            cart.clear();

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CustomersScreen(),
                              ),
                            );
                          },
                        ),
                      );
                    }else{
                      showDialog(
                        context: context,
                        builder: (_) => VentaFinalizadaDialog(
                          exitosa: false,
                          motivo: checkout.motivoNoVenta,
                          totalVenta: 0,
                          totalPagado: 0,
                          saldoPendiente: 0,
                          cantidadProductos: 0,
                          pagos: [],
                        ),
                      );
                    }
                  },
                ),
              )
            ]
          )
        )
      ),
    );
  }

  Widget _row(
    String title,
    String value,{
    bool bold=false,
    Color? color,
  }){

    return Row(

      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,

      children: [

        Text(
          title,
          style: TextStyle(
            fontWeight: bold
                    ? FontWeight.bold
                    : FontWeight.normal,
          ),
        ),

        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: bold
                    ? FontWeight.bold
                    : FontWeight.normal,
            fontSize: bold
                    ? 20
                    : 16,
          ),
        )

      ],
    );
  }
}