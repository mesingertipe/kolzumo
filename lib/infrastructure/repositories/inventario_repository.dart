import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/models/precios_model.dart';
import 'package:kolzumo_app/services/precios_service.dart';

import '../../services/inventario_service.dart';
import '../../services/promocion_service.dart';
import '../models/inventario_model.dart';
import '../models/promocion_model.dart';

class InventarioRepository {
  final InventarioService _inventarioService = InventarioService();
  final PromocionService _promocionService = PromocionService();
  final PreciosService _preciosService = PreciosService();

  Future<List<Inventario>> getInventario(int idVendedor) async {
    try {
      final respuestas = await Future.wait([
        _inventarioService.getInventarioParcial(idVendedor),
        _preciosService.getPrecios(),
        _promocionService.getPromociones(),
      ]);

      final List<Inventario> inventariosRaw = respuestas[0] as List<Inventario>;
      final List<Precios> precios = respuestas[1] as List<Precios>;
      final List<Promocion> promociones = respuestas[2] as List<Promocion>;

      final Map<int, Precios> preciosMap = {
        for (var precio in precios) precio.idproducto: precio
      };

      final Map<int, Promocion> promocionesMap = {
        for (var promo in promociones) promo.idproducto: promo
      };

      return inventariosRaw.map((raw) {
        return Inventario(
          idinventarioVendedor: raw.idinventarioVendedor, 
          cantidad: raw.cantidad, 
          porcentajeiva: raw.porcentajeiva, 
          idvendedor: raw.idvendedor, 
          nombrevendedor: raw.nombrevendedor, 
          idproducto: raw.idproducto, 
          nombreproducto: raw.nombreproducto,
          precio: preciosMap[raw.idproducto],
          promocion: promocionesMap[raw.idproducto]
        );
      }).toList();

    } catch (e) {
      debugPrint('Error en InventarioRepository: $e');
      rethrow;
    }
  }
}