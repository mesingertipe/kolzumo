import 'package:kolzumo_app/infrastructure/helpers/lista_venta_extension.dart';

import '../../infrastructure/models/inventario_model.dart';
import '../../infrastructure/models/resumen_dia_model.dart';
import '../database/database.dart';

class ResumenDiaRepository {
  final AppDatabase _db;

  ResumenDiaRepository(this._db);

  Future<ResumenDia> obtenerResumenDia({
    required int idvendedor,
    required String nombrevendedor,
    required String gps,
    DateTime? fecha,
  }) async {
    final dia = fecha ?? DateTime.now();

    // 1. Ventas completas del día en UN SOLO lote optimizado (sin N+1)
    final listaVentasCompletas = await _db.obtenerVentasCompletasDelDia(dia, nombrevendedor, gps);

    // 2. Inventario: solo productos con su cantidad, sin precio ni promoción
    final productos = await _db.catalogosDao.obtenerProductos();

    final listaInventario = productos.map((p) {
      return Inventario(
        idinventarioVendedor: p.id,
        cantidad: p.cantidad,
        porcentajeiva: p.porcentajeiva,
        idvendedor: idvendedor,
        nombrevendedor: nombrevendedor,
        idproducto: p.id,
        nombreproducto: p.nombre,
        precio: null,
        promocion: null,
      );
    }).toList();

    // 3. Ensambla el ResumenDia
    // idresumenvendedordia es local hasta que el backend lo confirme
    // al sincronizar. Usamos el timestamp del día como ID temporal.
    final idLocal = int.parse(
      '${dia.year}${dia.month.toString().padLeft(2, '0')}${dia.day.toString().padLeft(2, '0')}$idvendedor',
    );

    return ResumenDia(
      idresumenvendedordia: idLocal,
      idvendedor: idvendedor,
      nombrevendedor: nombrevendedor,
      fecha: DateTime(dia.year, dia.month, dia.day),
      listaventas: listaVentasCompletas,
      listainventario: listaInventario,
      mensaje: null,
    );
  }
}