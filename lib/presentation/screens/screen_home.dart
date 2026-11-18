import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/data/database/database.dart';
import 'package:kolzumo_app/infrastructure/formatters/currency_formatter.dart';
import 'package:kolzumo_app/infrastructure/models/seller_stats.dart';
import 'package:kolzumo_app/infrastructure/repositories/inventario_repository.dart';
import 'package:kolzumo_app/presentation/screens/printer_devices_screen.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/content_profile.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/list_customers.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/list_orders.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/menu_burguer.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/modal_inventario.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/operational_status_bar.dart';
import 'package:kolzumo_app/providers/ruta_provider.dart';
import 'package:kolzumo_app/providers/vehiculo_provider.dart';
import 'package:kolzumo_app/services/session_sync_service.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../logic/auth_logic.dart';
import '../../providers/orders_provider.dart';

class HomeApp extends StatefulWidget {
  final int initialTab;
  const HomeApp({super.key, this.initialTab = 0});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  late int _currentTab;
  bool _isSyncingCatalogs = false;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<Auth>().userAccount;
      if (user != null) {
        context
            .read<PedidosPendientesProvider>()
            .cargarPedidos(user.idvendedor);
      }
    });
  }

  Future<void> _resyncCatalogs() async {
    final user = context.read<Auth>().userAccount;
    if (user == null || _isSyncingCatalogs) return;

    setState(() => _isSyncingCatalogs = true);
    try {
      await context.read<SessionSyncService>().syncAll(user.idvendedor);
      if (!mounted) return;
      await context
          .read<PedidosPendientesProvider>()
          .cargarPedidos(user.idvendedor, forceRefresh: true);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catálogos, precios e inventario sincronizados'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al sincronizar: $e'),
          backgroundColor: AppTheme.dangerColor,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSyncingCatalogs = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pedidosProv = context.watch<PedidosPendientesProvider>();
    final titles = [
      'Jornada del Vendedor',
      'Clientes Activos',
      'Impresora Térmica',
      'Mi Perfil y Cierre',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentTab]),
        actions: [
          IconButton(
            tooltip: 'Sincronizar datos con servidor',
            onPressed: _isSyncingCatalogs ? null : _resyncCatalogs,
            icon: _isSyncingCatalogs
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.sync_rounded),
          ),
          IconButton(
            tooltip: 'Configuración y Seguridad',
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
            icon: const Icon(Icons.security_rounded),
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/home'),
      body: Column(
        children: [
          OperationalStatusBar(
            onTapRoute: () => Navigator.of(context).pushNamed('/ruta'),
            onTapPrinter: () => setState(() => _currentTab = 2),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                _JornadaDashboardTab(
                  onGoToClients: () => setState(() => _currentTab = 1),
                  onGoToPrinters: () => setState(() => _currentTab = 2),
                ),
                const ListCustomers(),
                const ThermalPrinterScreen(embedded: true),
                const ContentProfile(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (idx) => setState(() => _currentTab = idx),
        destinations: [
          NavigationDestination(
            icon: Badge(
              isLabelVisible: pedidosProv.pedidos.isNotEmpty,
              label: Text('${pedidosProv.pedidos.length}'),
              child: const Icon(Icons.dashboard_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: pedidosProv.pedidos.isNotEmpty,
              label: Text('${pedidosProv.pedidos.length}'),
              child: const Icon(Icons.dashboard_rounded),
            ),
            label: 'Jornada',
          ),
          const NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront_rounded),
            label: 'Clientes',
          ),
          const NavigationDestination(
            icon: Icon(Icons.print_outlined),
            selectedIcon: Icon(Icons.print_rounded),
            label: 'Impresora',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Perfil y Cierre',
          ),
        ],
      ),
    );
  }
}

class _JornadaDashboardTab extends StatelessWidget {
  final VoidCallback onGoToClients;
  final VoidCallback onGoToPrinters;

  const _JornadaDashboardTab({
    required this.onGoToClients,
    required this.onGoToPrinters,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.watch<Auth>().userAccount;
    final pedidosProv = context.watch<PedidosPendientesProvider>();
    final rutaProv = context.watch<RutaProvider>();
    final vehiculoProv = context.watch<VehiculoProvider>();
    final database = context.read<AppDatabase>();

    final statsStream = Rx.combineLatest2(
      database.ventasDao.watchVentasCount(),
      database.ventasDao.watchTotalEfectivoRecibido(),
      (int ventas, double efectivo) => SellerStats(
        ventasRealizadas: ventas,
        clientesVisitados: ventas,
        efectivoRecibido: efectivo,
      ),
    );

    return RefreshIndicator(
      onRefresh: () async {
        if (user != null) {
          await pedidosProv.cargarPedidos(user.idvendedor, forceRefresh: true);
        }
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Tarjeta de bienvenida y KPIs en tiempo real
          StreamBuilder<SellerStats>(
            stream: statsStream,
            builder: (context, snapshot) {
              final stats = snapshot.data ??
                  const SellerStats(
                    ventasRealizadas: 0,
                    clientesVisitados: 0,
                    efectivoRecibido: 0,
                  );

              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppTheme.forestDark, AppTheme.primaryColor],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white.withValues(alpha: 0.18),
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hola, ${user?.nombre ?? "Vendedor"}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user?.nombreperfil ?? 'Vendedor en Ruta',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _KpiTile(
                            label: 'Recaudo Hoy',
                            value: CurrencyFormatter.toCOP(
                              stats.efectivoRecibido,
                            ),
                            icon: Icons.payments_outlined,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _KpiTile(
                            label: 'Facturas',
                            value: '${stats.ventasRealizadas}',
                            icon: Icons.receipt_long_outlined,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _KpiTile(
                            label: 'Visitados',
                            value: '${stats.clientesVisitados}',
                            icon: Icons.storefront_outlined,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Tarjeta de Configuración de Ruta / Iniciar Día
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.secondColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.route_rounded,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ruta y Vehículo del Día',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.5,
                                color: AppTheme.forestDark,
                              ),
                            ),
                            Text(
                              rutaProv.rutaSeleccionada != null
                                  ? 'Ruta: ${rutaProv.rutaSeleccionada!.nombreruta} • Placa: ${vehiculoProv.vehiculoSeleccionado?.placa ?? "Sin placa"}'
                                  : 'Selecciona tu ruta y vehículo para iniciar o cambiar de zona.',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            if (user == null) return;
                            final inventarios = await InventarioRepository()
                                .getInventario(user.idvendedor);
                            if (!context.mounted) return;
                            showDialog(
                              context: context,
                              builder: (_) =>
                                  ModalInventario(inventarios: inventarios),
                            );
                          },
                          icon: const Icon(Icons.inventory_2_outlined, size: 18),
                          label: const Text('Ver Inventario'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/ruta'),
                          icon: const Icon(Icons.edit_road_rounded, size: 18),
                          label: Text(
                            rutaProv.rutaSeleccionada == null
                                ? 'Iniciar Día'
                                : 'Cambiar Ruta',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Sección de Pedidos Pendientes por Aprobar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pedidos Pendientes por Aprobar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.forestDark,
                ),
              ),
              if (user != null)
                TextButton.icon(
                  onPressed: pedidosProv.loading
                      ? null
                      : () => pedidosProv.cargarPedidos(
                            user.idvendedor,
                            forceRefresh: true,
                          ),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Actualizar'),
                ),
            ],
          ),
          const SizedBox(height: 4),
          if (pedidosProv.loading)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            ListOrders(
              orders: pedidosProv.pedidos,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
        ],
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _KpiTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.accentLime, size: 18),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
