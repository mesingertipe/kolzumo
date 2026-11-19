import 'package:flutter/material.dart';
import 'package:kolzumo_app/controllers/thermal_printer_controller.dart';
import 'package:kolzumo_app/infrastructure/formatters/currency_formatter.dart';
import 'package:kolzumo_app/infrastructure/models/cliente_model.dart';
import 'package:kolzumo_app/providers/cliente_provider.dart';
import 'package:kolzumo_app/providers/ruta_provider.dart';
import 'package:provider/provider.dart';

import '../../../config/app_theme.dart';

class ListCustomers extends StatefulWidget {
  const ListCustomers({super.key});

  @override
  State<ListCustomers> createState() => _ListCustomersState();
}

class _ListCustomersState extends State<ListCustomers> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleSelectCustomer(BuildContext context, Cliente customerItem) {
    final printer = context.read<ThermalPrinterController>();

    // Regla de negocio: Para ejecutar el proceso de venta debe estar conectada
    // la impresora Bluetooth o tener habilitado el Modo Impresora Virtual.
    if (!printer.canOperate) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.dangerColor,
          duration: const Duration(seconds: 4),
          content: const Text(
            'Debe conectar a una impresora (o activar Impresora Virtual) antes de vender.',
          ),
          action: SnackBarAction(
            label: 'Conectar',
            textColor: Colors.white,
            onPressed: () => Navigator.of(context).pushNamed('/printers'),
          ),
        ),
      );
      return;
    }

    context.read<ClienteProvider>().seleccionarCliente(customerItem);
    Navigator.pushNamed(context, '/stock');
  }

  @override
  Widget build(BuildContext context) {
    final clientesProvider = context.watch<ClienteProvider>();
    final rutaSeleccionada = context.watch<RutaProvider>().rutaSeleccionada;

    if (clientesProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (clientesProvider.clientes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppTheme.secondColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  rutaSeleccionada != null
                      ? Icons.group_off_rounded
                      : Icons.edit_road_rounded,
                  size: 56,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                rutaSeleccionada != null
                    ? 'No hay clientes registrados en la ruta "${rutaSeleccionada.nombreruta}".'
                    : 'Aún no has seleccionado una ruta de trabajo.',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.forestDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Selecciona o cambia tu ruta activa para consultar los clientes asignados.',
                style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pushNamed('/ruta'),
                icon: const Icon(Icons.route_rounded),
                label: const Text('Seleccionar Ruta'),
              ),
            ],
          ),
        ),
      );
    }

    final filtered = clientesProvider.clientes.where((c) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return c.nombreestablecimiento.toLowerCase().contains(q) ||
          c.administrador.toLowerCase().contains(q) ||
          c.documento.toLowerCase().contains(q) ||
          c.direccion.toLowerCase().contains(q);
    }).toList();

    return Column(
      children: [
        // Barra de búsqueda instantánea
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _query = val.trim()),
            decoration: InputDecoration(
              hintText: 'Buscar por comercio, cliente, NIT o dirección...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${filtered.length} cliente(s) en ${rutaSeleccionada?.nombreruta ?? "ruta"}',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              if (rutaSeleccionada != null)
                TextButton.icon(
                  onPressed: () => clientesProvider.cargarClientes(
                    rutaSeleccionada.nombreruta,
                    rutaId: rutaSeleccionada.idruta,
                    forceRefresh: true,
                  ),
                  icon: const Icon(Icons.refresh, size: 16),
                  label: const Text('Refrescar'),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
            itemCount: filtered.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final customerItem = filtered[index];
              final hasCredit =
                  customerItem.credito.toLowerCase() == 'si' ||
                      customerItem.pagocredito == 1;

              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _handleSelectCustomer(context, customerItem),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppTheme.secondColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.storefront_rounded,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    customerItem.nombreestablecimiento,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppTheme.forestDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${customerItem.administrador} • NIT/CC: ${customerItem.documento}',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: hasCredit
                                    ? AppTheme.secondColor
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                hasCredit ? 'Crédito' : 'Contado',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: hasCredit
                                      ? AppTheme.primaryColor
                                      : Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 15,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${customerItem.direccion} (${customerItem.nombreruta})',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Wrap(
                              spacing: 8,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    customerItem.nombrecategoriaCliente,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                                if (hasCredit && customerItem.cupo > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.secondColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'Cupo: ${CurrencyFormatter.toCOP(customerItem.cupo.toString())}',
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            FilledButton.tonalIcon(
                              onPressed: () =>
                                  _handleSelectCustomer(context, customerItem),
                              icon: const Icon(
                                Icons.shopping_bag_outlined,
                                size: 17,
                              ),
                              label: const Text('Vender'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
