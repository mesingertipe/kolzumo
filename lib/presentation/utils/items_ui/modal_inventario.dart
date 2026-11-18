import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/data/database/database.dart';
import 'package:kolzumo_app/infrastructure/models/inventario_model.dart';
import 'package:kolzumo_app/infrastructure/repositories/inventario_repo_db.dart';
import 'package:kolzumo_app/logic/auth_logic.dart';
import 'package:kolzumo_app/presentation/utils/items_ui/listview_inventario.dart';
import 'package:kolzumo_app/services/inventario_service.dart';
import 'package:kolzumo_app/services/storage_service.dart';
import 'package:kolzumo_app/services/vendedor_service.dart';
import 'package:provider/provider.dart';

import '../../../providers/orders_provider.dart';

class ModalInventario extends StatefulWidget {
  final List<Inventario> inventarios;
  final String? origen;
  final int? idPedido;
  final VoidCallback? onApproved;

  const ModalInventario({
    super.key,
    required this.inventarios,
    this.origen,
    this.idPedido,
    this.onApproved,
  });

  @override
  State<ModalInventario> createState() => _ModalInventarioState();
}

class _ModalInventarioState extends State<ModalInventario> {
  bool _isProcessing = false;

  Future<void> _handleApprove() async {
    setState(() => _isProcessing = true);
    final ordersPending = context.read<PedidosPendientesProvider>();
    final auth = context.read<Auth>();
    final database = context.read<AppDatabase>();
    final user = auth.userAccount;

    try {
      if (widget.origen == 'home') {
        final targetId = widget.idPedido ?? ordersPending.getIdPedido();
        if (targetId > 0) {
          await ordersPending.aprobarPedido(targetId);
        }
      }

      if (user != null) {
        // Sincroniza el inventario aprobado en la base de datos local Drift
        final invRepo = InventarioRepositoryDB(
          database,
          InventarioService(),
          user.idvendedor,
        );
        await invRepo.sincronizarProductos();

        // Sincroniza y guarda el formato de consecutivo dinámico del vendedor
        try {
          final vend = await VendedorService().getConsecutivo(user.idvendedor);
          final parsed = vend.parseConsecutivo();
          await StorageService().saveConsecutivoFormat(
            idVendedor: user.idvendedor,
            prefix: parsed.prefix,
            padWidth: parsed.padWidth,
          );
        } catch (_) {}
      }

      if (!mounted) return;
      Navigator.pop(context, true);
      widget.onApproved?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.primaryColor,
          content: Text(
            widget.origen == 'home'
                ? 'Pedido aprobado e inventario actualizado'
                : 'Jornada iniciada e inventario confirmado',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalUnits = widget.inventarios.fold<int>(
      0,
      (sum, item) => sum + item.cantidad,
    );

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.78,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Encabezado estilo KolZumo Enterprise
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: const BoxDecoration(
                color: AppTheme.forestDark,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.inventory_2_rounded,
                    color: AppTheme.accentLime,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.origen == 'home'
                              ? 'Aprobar Pedido Asignado'
                              : 'Inventario Asignado',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.inventarios.length} referencias • $totalUnits unidades totales',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
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
                      color: AppTheme.accentLime.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${widget.inventarios.length}',
                      style: const TextStyle(
                        color: AppTheme.accentLime,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Lista de productos
            Expanded(
              child: widget.inventarios.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.inventory_outlined,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'No hay productos en este cargue',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: widget.inventarios.length,
                      itemBuilder: (context, index) {
                        return ListviewInventario(
                          index: index,
                          item: widget.inventarios[index],
                        );
                      },
                    ),
            ),

            const Divider(height: 1),

            // Botones Aceptar / Rechazar
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: _isProcessing || widget.inventarios.isEmpty
                        ? null
                        : _handleApprove,
                    icon: _isProcessing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.check_circle_outline),
                    label: Text(
                      _isProcessing ? 'Procesando...' : 'Aceptar Inventario',
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed:
                        _isProcessing ? null : () => Navigator.pop(context, false),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Rechazar / Volver'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
