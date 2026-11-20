import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/data/database/database.dart';
import 'package:kolzumo_app/infrastructure/models/inventario_model.dart';
import 'package:kolzumo_app/infrastructure/repositories/inventario_repo_db.dart';
import 'package:kolzumo_app/logic/auth_logic.dart';
import 'package:kolzumo_app/services/inventario_service.dart';
import 'package:kolzumo_app/services/storage_service.dart';
import 'package:kolzumo_app/services/vendedor_service.dart';
import 'package:provider/provider.dart';

/// Pantalla Completa de Inventario Asignado en Camión.
/// Reemplaza completamente los antiguos popups flotantes pequeños
/// por una experiencia ágil con buscador rápido, estadísticas por presentación
/// y confirmación fluida para 20+ productos.
class AssignedInventoryScreen extends StatefulWidget {
  final List<Inventario> inventarios;
  final bool isStartingDay;
  final VoidCallback? onConfirmed;

  const AssignedInventoryScreen({
    super.key,
    required this.inventarios,
    this.isStartingDay = false,
    this.onConfirmed,
  });

  @override
  State<AssignedInventoryScreen> createState() => _AssignedInventoryScreenState();
}

class _AssignedInventoryScreenState extends State<AssignedInventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isProcessing = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleConfirm() async {
    setState(() => _isProcessing = true);
    final auth = context.read<Auth>();
    final database = context.read<AppDatabase>();
    final user = auth.userAccount;

    try {
      if (user != null) {
        // Sincroniza el inventario en la base de datos local SQLite (Drift)
        final invRepo = InventarioRepositoryDB(
          database,
          InventarioService(),
          user.idvendedor,
        );
        await invRepo.sincronizarProductos();

        // Asegura formato de consecutivo
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
      HapticFeedback.mediumImpact();
      Navigator.pop(context, true);
      widget.onConfirmed?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.primaryColor,
          content: Text(
            widget.isStartingDay
                ? 'Jornada iniciada e inventario confirmado con éxito'
                : 'Inventario de camión verificado',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.dangerColor,
          content: Text('Error al procesar: $e'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filtered = widget.inventarios.where((item) {
      if (_searchQuery.isEmpty) return true;
      return item.nombreproducto
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();

    final totalUnits = widget.inventarios.fold<int>(
      0,
      (sum, item) => sum + item.cantidad,
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isStartingDay
                  ? 'Confirmar Carga de Inicio'
                  : 'Inventario Asignado en Camión',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.inventarios.length} referencias • $totalUnits unidades totales',
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Barra de búsqueda rápida
          Container(
            color: isDark ? AppTheme.darkSurface : AppTheme.forestDark,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v.trim()),
              decoration: InputDecoration(
                hintText: 'Buscar producto o referencia...',
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

          // Resumen superior en chips métricos
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkCard : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppTheme.darkBorder : Colors.grey.shade200,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkBorder : AppTheme.secondColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.inventory_2_rounded,
                          color: isDark ? AppTheme.accentLime : AppTheme.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$totalUnits uds',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isDark ? Colors.white : AppTheme.forestDark,
                              ),
                            ),
                            Text(
                              'Carga total',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkBorder : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.category_rounded,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.inventarios.length} refs',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isDark ? Colors.white : AppTheme.forestDark,
                              ),
                            ),
                            Text(
                              'Referencias',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de referencias con cantidades destacadas
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 54,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No se encontraron productos con "$_searchQuery"',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppTheme.darkBorder : Colors.grey.shade200,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Número correlativo
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: isDark
                                  ? AppTheme.darkBorder
                                  : AppTheme.secondColor,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppTheme.accentLime
                                      : AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Nombre del producto
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.nombreproducto,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Código: ${item.idproducto}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Badge de Cantidad
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: item.cantidad > 0
                                    ? (isDark
                                        ? AppTheme.accentLime.withValues(alpha: 0.15)
                                        : AppTheme.secondColor)
                                    : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: item.cantidad > 0
                                      ? (isDark
                                          ? AppTheme.accentLime
                                          : AppTheme.primaryColor)
                                      : AppTheme.dangerColor,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                '${item.cantidad} uds',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                  color: item.cantidad > 0
                                      ? (isDark
                                          ? AppTheme.accentLime
                                          : AppTheme.primaryColor)
                                      : AppTheme.dangerColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Botón inferior fijo para aceptar / continuar
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: FilledButton.icon(
            onPressed: _isProcessing ? null : _handleConfirm,
            icon: _isProcessing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_circle_rounded),
            label: Text(
              _isProcessing
                  ? 'Guardando...'
                  : (widget.isStartingDay
                      ? 'Confirmar e Iniciar Ruta'
                      : 'Aceptar y Volver'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
