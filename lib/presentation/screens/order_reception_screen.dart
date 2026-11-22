import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:kolzumo_app/data/database/database.dart';
import 'package:kolzumo_app/infrastructure/models/pedido_pendiente_model.dart';
import 'package:kolzumo_app/infrastructure/repositories/inventario_repo_db.dart';
import 'package:kolzumo_app/logic/auth_logic.dart';
import 'package:kolzumo_app/providers/orders_provider.dart';
import 'package:kolzumo_app/services/inventario_service.dart';
import 'package:kolzumo_app/services/storage_service.dart';
import 'package:kolzumo_app/services/vendedor_service.dart';
import 'package:provider/provider.dart';

/// Pantalla Completa de Recepción y Auditoría de Carga (Checklist para 20+ productos).
/// Reemplaza el antiguo modal popup por una experiencia táctil, rápida y sin errores.
class OrderReceptionScreen extends StatefulWidget {
  final PedidosPendientes order;

  const OrderReceptionScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderReceptionScreen> createState() => _OrderReceptionScreenState();
}

class _OrderReceptionScreenState extends State<OrderReceptionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isProcessing = false;

  // Estado de chequeo por producto: idproducto -> verificado (bool)
  late Map<int, bool> _verifiedMap;
  // Cantidad real recibida por producto: idproducto -> cantidad
  late Map<int, int> _receivedQuantities;

  @override
  void initState() {
    super.initState();
    _verifiedMap = {
      for (var d in widget.order.detallepedidovendedor) d.idproducto: false,
    };
    _receivedQuantities = {
      for (var d in widget.order.detallepedidovendedor) d.idproducto: d.cantidad,
    };
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleVerify(int idProducto) {
    HapticFeedback.lightImpact();
    setState(() {
      _verifiedMap[idProducto] = !(_verifiedMap[idProducto] ?? false);
    });
  }

  void _verifyAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      for (var k in _verifiedMap.keys) {
        _verifiedMap[k] = true;
      }
    });
  }

  Future<void> _adjustQuantity(int idProducto, String nombre, int cantidadActual) async {
    final controller = TextEditingController(text: cantidadActual.toString());
    final newQty = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Ajustar cantidad: $nombre',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingresa la cantidad física realmente recibida en el camión:',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Unidades recibidas',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final val = int.tryParse(controller.text);
              if (val != null && val >= 0) {
                Navigator.pop(ctx, val);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (newQty != null) {
      setState(() {
        _receivedQuantities[idProducto] = newQty;
        _verifiedMap[idProducto] = true;
      });
    }
  }

  Future<void> _handleConfirmReceipt() async {
    final unverifiedCount = _verifiedMap.values.where((v) => !v).length;
    if (unverifiedCount > 0) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Ítems sin verificar'),
          content: Text(
            'Tienes $unverifiedCount productos sin marcar como verificados. ¿Deseas aprobar la recepción completa de todos modos?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Revisar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Sí, Aprobar Todo'),
            ),
          ],
        ),
      );
      if (proceed != true || !mounted) return;
    }

    if (!mounted) return;
    setState(() => _isProcessing = true);
    final ordersPending = context.read<PedidosPendientesProvider>();
    final auth = context.read<Auth>();
    final database = context.read<AppDatabase>();
    final user = auth.userAccount;

    try {
      await ordersPending.aprobarPedido(widget.order.idpedidovendedor);

      if (user != null) {
        // Sincroniza el inventario aprobado en la base de datos local SQLite / Drift
        final invRepo = InventarioRepositoryDB(
          database,
          InventarioService(),
          user.idvendedor,
        );
        await invRepo.sincronizarProductos();

        // Actualiza el consecutivo dinámico del vendedor
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.primaryColor,
          content: Text(
            '¡Pedido #${widget.order.idpedidovendedor} aprobado con éxito! Tu inventario ya está cargado.',
          ),
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppTheme.dangerColor,
          content: Text('Error al aprobar la carga: $e'),
        ),
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.order.detallepedidovendedor;
    final filteredDetails = details.where((d) {
      if (_searchQuery.trim().isEmpty) return true;
      return d.nombreproducto.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final totalVerified = _verifiedMap.values.where((v) => v).length;
    final totalItems = details.length;
    final progress = totalItems > 0 ? (totalVerified / totalItems) : 0.0;
    final totalUnits = _receivedQuantities.values.fold<int>(0, (sum, q) => sum + q);

    return Scaffold(
      backgroundColor: AppTheme.surfaceBg,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recepción de Carga #${widget.order.idpedidovendedor}',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            Text(
              'Bodega ${widget.order.idbodega} • $totalUnits unidades totales',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: _verifyAll,
            icon: const Icon(Icons.done_all_rounded, color: Colors.white, size: 20),
            label: const Text(
              'Marcar Todo',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Tarjeta de Progreso de Auditoría
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progreso de Verificación',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    Text(
                      '$totalVerified / $totalItems productos (${(progress * 100).toInt()}%)',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                ),
                const SizedBox(height: 12),
                // Buscador en tiempo real para listas grandes
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Buscar producto por nombre...',
                    hintStyle: TextStyle(fontSize: 13.5, color: Colors.grey.shade500),
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    isDense: true,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2. Lista de Productos en Tarjetas Táctiles
          Expanded(
            child: filteredDetails.isEmpty
                ? const Center(
                    child: Text(
                      'No se encontraron productos con ese nombre.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 90),
                    itemCount: filteredDetails.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = filteredDetails[index];
                      final isVerified = _verifiedMap[item.idproducto] ?? false;
                      final receivedQty = _receivedQuantities[item.idproducto] ?? item.cantidad;
                      final hasDiscrepancy = receivedQty != item.cantidad;

                      return Card(
                        elevation: isVerified ? 0.5 : 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isVerified
                                ? AppTheme.primaryColor.withValues(alpha: 0.4)
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        color: isVerified
                            ? AppTheme.secondColor.withValues(alpha: 0.25)
                            : Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _toggleVerify(item.idproducto),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Checkbox Circular Táctil Grande
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isVerified
                                        ? AppTheme.primaryColor
                                        : Colors.grey.shade100,
                                    border: Border.all(
                                      color: isVerified
                                          ? AppTheme.primaryColor
                                          : Colors.grey.shade400,
                                      width: 2,
                                    ),
                                  ),
                                  child: isVerified
                                      ? const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 14),

                                // Datos del Producto
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.nombreproducto,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.5,
                                          color: isVerified
                                              ? AppTheme.forestDark
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            'Despachado: ${item.cantidad} uds',
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          if (hasDiscrepancy) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.amber.shade100,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                'Recibes: $receivedQty uds',
                                                style: TextStyle(
                                                  fontSize: 11.5,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.amber.shade900,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // Botón para reportar novedad / ajustar
                                IconButton(
                                  tooltip: 'Reportar novedad o faltante',
                                  icon: const Icon(
                                    Icons.edit_note_rounded,
                                    color: AppTheme.primaryColor,
                                    size: 26,
                                  ),
                                  onPressed: () => _adjustQuantity(
                                    item.idproducto,
                                    item.nombreproducto,
                                    receivedQty,
                                  ),
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
      ),

      // 3. Barra de Aprobación Inferior Fija (Respetando el área segura del sistema Android)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                ),
                onPressed: _isProcessing ? null : _handleConfirmReceipt,
                icon: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline_rounded, size: 22),
                label: Text(
                  _isProcessing
                      ? 'Aprobando y cargando inventario...'
                      : 'Aprobar Carga ($totalUnits Unidades)',
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

