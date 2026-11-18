import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/models/metodopago_model.dart';
import 'package:kolzumo_app/providers/cart_provider.dart';
import 'package:kolzumo_app/providers/cliente_provider.dart';
import 'package:kolzumo_app/providers/checkout_provider.dart';
import 'package:kolzumo_app/providers/inventario_provider.dart';
import 'package:kolzumo_app/providers/precio_provider.dart';
import 'package:kolzumo_app/services/metodopago_service.dart';
import 'package:provider/provider.dart';

import '../utils/items_ui/checkout_resumen_data.dart';
import '../utils/items_ui/checkout_summary.dart';
import '../utils/items_ui/page_indicator.dart';
import 'resumen_productos_page.dart';
import 'seleccion_pago_page.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutScreen> {
  final _metodosPagoService = MetodopagoService();
  final _pageController = PageController();

  static const _totalPages = 2;

  List<MetodoPago> metodos = [];
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadMetodosPago();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadMetodosPago() async {
    final metodospagoProvider = context.read<CheckoutProvider>();

    final metodosPago = await _metodosPagoService.getMetodosPago();
    metodospagoProvider.loadMetodosPago(metodosPago);

    setState(() {
      metodos = metodosPago;
    });
  }

  void _irASiguiente() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _irAAnterior() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _vaciarCarritoYSalir(CartProvider cart, CheckoutProvider checkout) {
    cart.clear();
    checkout.clearTipoPago();
    Navigator.pop(context, '/stock');
  }

  @override
  Widget build(BuildContext context) {
    // Providers
    final inventario = context.watch<InventarioProvider>();
    final precio = context.watch<PreciosProvider>();
    final cliente = context.watch<ClienteProvider>();
    final checkout = context.watch<CheckoutProvider>();
    final cart = context.watch<CartProvider>();

    final customerSel = cliente.clienteSeleccionado!;

    final resumen = calcularResumenCheckout(
      cart: cart,
      inventario: inventario,
      precio: precio,
      customerSel: customerSel,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentPage == 0
              ? 'Carrito: ${customerSel.nombreestablecimiento}'
              : 'Pago: ${customerSel.nombreestablecimiento}',
        ),
        centerTitle: true,
        leading: _currentPage == 0
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _irAAnterior,
              ),
        actions: [
          IconButton(
            color: Theme.of(context).colorScheme.error,
            onPressed: () => _vaciarCarritoYSalir(cart, checkout),
            icon: const Icon(Icons.remove_shopping_cart),
          ),
        ],
      ),
      body: Column(
        children: [
          CheckoutPageIndicator(
            totalPages: _totalPages,
            currentPage: _currentPage,
          ),

          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) => setState(() => _currentPage = index),
              children: [
                CheckoutResumenPage(
                  items: resumen.items,
                  inventario: inventario,
                  precio: precio,
                  cliente: customerSel,
                  promociones: resumen.promocionesItems,
                  mostrarPromociones:
                      resumen.aplicaPromocion || resumen.tieneDescuento,
                ),
                CheckoutPagoPage(
                  checkout: checkout,
                  metodos: metodos,
                ),
              ],
            ),
          ),

          if(_currentPage != 0)
            CheckoutSummary(
              subtotal: resumen.total,
              descuento: resumen.tieneDescuento ? resumen.descuento : 0,
              iva: resumen.discriminaIVA ? resumen.valorIVA : 0,
            ),

          if (_currentPage == 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _irASiguiente,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Continuar al pago'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
