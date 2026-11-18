import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/data/database/daos/precios_dao.dart';
import 'package:kolzumo_app/data/database/database.dart';
import 'package:kolzumo_app/infrastructure/models/inventario_model.dart';
import 'package:kolzumo_app/infrastructure/models/precios_model.dart';
import 'package:kolzumo_app/infrastructure/models/promocion_model.dart' as modelprom;
import 'package:kolzumo_app/presentation/utils/items_ui/bottom_sheet_stock.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/cart_icon_badge.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/cart_item_widget.dart';
import 'package:kolzumo_app/providers/cliente_provider.dart';
import 'package:kolzumo_app/providers/precio_provider.dart';
import 'package:kolzumo_app/providers/ruta_provider.dart';
import 'package:kolzumo_app/services/precios_service.dart';
import 'package:provider/provider.dart';

import '../../infrastructure/repositories/inventario_repo_db.dart';
import '../../logic/auth_logic.dart';
import '../../providers/cart_provider.dart';
import '../../providers/inventario_provider.dart';
import '../../services/inventario_service.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StockWidgetState();
}

class _StockWidgetState extends State<StockScreen> {
  final _precioService = PreciosService();
  final TextEditingController _searchController = TextEditingController();

  List<Inventario> stock = [];
  List<Precios> precios = [];
  bool isLoading = true;
  String _searchQuery = '';

  final _bottomSheetKey = GlobalKey();
  double _bottomSheetHeight = 96;

  @override
  void initState() {
    super.initState();
    _loadInventario();
    WidgetsBinding.instance.addPostFrameCallback((_) => _medirBottomSheet());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInventario() async {
    final inventarioServi = InventarioService();

    final database = context.read<AppDatabase>();
    final authProvider = context.read<Auth>();
    final customerProvider = context.read<ClienteProvider>();
    final rutaProvider = context.read<RutaProvider>();
    final precioProvider = context.read<PreciosProvider>();
    final inventarioProvider = context.read<InventarioProvider>();

    try {
      final syncState = await database.catalogosDao.getEstadoSincronizacion();

      if (syncState == null || !syncState) {
        try {
          final inventarioRepoDB = InventarioRepositoryDB(
            database,
            inventarioServi,
            authProvider.userAccount!.idvendedor,
          );
          await inventarioRepoDB.sincronizarProductos();
          await database.catalogosDao.saveSincronizacion();
        } catch (e) {
          debugPrint('Modo offline al cargar stock: $e');
        }
      }

      // 1. Consulta precios desde SQLite local (100% Offline-First)
      final preciosDay =
          await database.preciosDao.watchPreciosDelDia(DateTime.now()).first;

      final preciosDB = <int, PrecioDetallado>{
        for (final p in preciosDay)
          if (p.categoriaCliente.id ==
              customerProvider.clienteSeleccionado!.idcategoriaCliente)
            p.precio.productoId: p,
      };

      // Construye la lista local de Precios desde SQLite para PreciosProvider
      List<Precios> precioData = preciosDay
          .map(
            (p) => Precios(
              idprecio: p.precio.id,
              idproducto: p.producto.id,
              nombreproducto: p.producto.nombre,
              idcategoriacliente: p.categoriaCliente.id,
              categoriacliente: p.categoriaCliente.nombre,
              valor: p.precio.valor,
              mensaje: null,
            ),
          )
          .toList();

      // Si SQLite no tenía precios, intenta descargarlos como respaldo
      if (precioData.isEmpty) {
        try {
          precioData = await _precioService.getPrecios();
        } catch (_) {}
      }

      final resultado = await database.promocionesDao.productosConPromocionVigente(
        clienteId: customerProvider.clienteSeleccionado!.idcliente,
        rutaId: rutaProvider.rutaSeleccionada!.idruta,
        categoriaClienteId:
            customerProvider.clienteSeleccionado!.idcategoriaCliente,
      );

      final stockData = resultado.map((r) {
        final precioDetallado = preciosDB[r.producto.id];

        return Inventario(
          idinventarioVendedor: r.producto.id,
          cantidad: r.producto.cantidad,
          porcentajeiva: r.producto.porcentajeiva,
          idvendedor: authProvider.userAccount!.idvendedor,
          nombrevendedor: authProvider.userAccount!.nombre,
          idproducto: r.producto.id,
          nombreproducto: r.producto.nombre,
          precio: precioDetallado == null
              ? null
              : Precios(
                  idprecio: precioDetallado.precio.id,
                  idproducto: precioDetallado.producto.id,
                  nombreproducto: precioDetallado.producto.nombre,
                  idcategoriacliente: precioDetallado.categoriaCliente.id,
                  categoriacliente: precioDetallado.categoriaCliente.nombre,
                  valor: precioDetallado.precio.valor,
                  mensaje: null,
                ),
          promocion: r.promocion == null
              ? null
              : modelprom.Promocion(
                  idpromocion: r.promocion!.idpromocion,
                  promocionpara: r.promocion!.promocionpara,
                  promocionde: r.promocion!.promocionde,
                  cantidadventa: r.promocion!.cantidadventa,
                  cantidadsobreventa: r.promocion!.cantidadsobreventa,
                  porcentajesobreventa: r.promocion!.porcentajesobreventa,
                  fechadesde: r.promocion!.fechadesde,
                  fechahasta: r.promocion!.fechahasta,
                  idproducto: r.promocion!.productoId,
                  producto: r.producto.nombre,
                  idpromocionruta: r.promocion!.rutaId,
                  nombrepromocionruta: rutaProvider.rutaSeleccionada!.nombreruta,
                  idpromocioncatcli: r.promocion!.categoriaClienteId,
                  nombrepromocioncatcli: customerProvider
                      .clienteSeleccionado!.nombrecategoriaCliente,
                  listaclientespromocion: [],
                ),
        );
      }).toList();

      inventarioProvider.setInventarios(stockData);
      precioProvider.setPrecios(precioData);

      if (!mounted) return;
      setState(() {
        stock = stockData;
        precios = precioData;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error cargando inventario: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _medirBottomSheet() {
    final ctx = _bottomSheetKey.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox;
    final nuevaAltura = box.size.height;

    if (nuevaAltura != _bottomSheetHeight) {
      setState(() => _bottomSheetHeight = nuevaAltura);
    }
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = context.watch<ClienteProvider>();
    final inventarioProv = context.watch<InventarioProvider>();
    final precio = context.watch<PreciosProvider>();
    final cart = context.watch<CartProvider>();

    final customer = customerProvider.clienteSeleccionado;
    if (customer == null) {
      return const Scaffold(
        body: Center(child: Text('Selecciona un cliente primero.')),
      );
    }

    final items = cart.items.entries.toList();
    final total = cart.calcularTotal(items, inventarioProv, precio, customer);

    final filteredStock = stock.where((item) {
      if (_searchQuery.isEmpty) return true;
      return item.nombreproducto
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              customer.nombreestablecimiento,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '${customer.nombrecategoriaCliente} • ${customer.credito.toLowerCase() == "si" ? "Crédito" : "Contado"}',
              style: const TextStyle(fontSize: 11.5, color: Colors.white70),
            ),
          ],
        ),
        actions: const [CartIconBadge()],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : stock.isEmpty
              ? const Center(child: Text('No hay productos en el inventario.'))
              : Column(
                  children: [
                    Container(
                      color: AppTheme.forestDark,
                      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (v) =>
                            setState(() => _searchQuery = v.trim()),
                        decoration: InputDecoration(
                          hintText: 'Buscar producto en el inventario...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.only(
                          left: 12,
                          right: 12,
                          top: 12,
                          bottom: _bottomSheetHeight + 24,
                        ),
                        itemCount: filteredStock.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final inventarioItem = filteredStock[index];
                          return CartItemWidget(
                            stockItem: inventarioItem,
                            cliente: customer,
                          );
                        },
                      ),
                    ),
                  ],
                ),
      bottomSheet: Container(
        key: _bottomSheetKey,
        child: BottomSheetStock(
          total: total,
          cart: cart,
          cliente: customer,
        ),
      ),
    );
  }
}
