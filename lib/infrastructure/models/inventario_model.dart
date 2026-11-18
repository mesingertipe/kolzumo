import 'package:kolzumo_app/infrastructure/models/precios_model.dart';

import 'pedido_pendiente_model.dart';
import 'promocion_model.dart';

class Inventario {
  final int idinventarioVendedor;
  final int cantidad;
  final int porcentajeiva;
  final int idvendedor;
  final String nombrevendedor;
  final int idproducto;
  final String nombreproducto;
  Precios? precio;
  Promocion? promocion;

  Inventario({
      required this.idinventarioVendedor,
      required this.cantidad,
      required this.porcentajeiva,
      required this.idvendedor,
      required this.nombrevendedor,
      required this.idproducto,
      required this.nombreproducto,
      this.precio,
      this.promocion,
  });

  Inventario copyWith({
    int? idinventarioVendedor,
    int? cantidad,
    int? porcentajeiva,
    int? idvendedor,
    String? nombrevendedor,
    int? idproducto,
    String? nombreproducto,
    Precios? precio,
    Promocion? promocion,
  }) {
    return Inventario(
      idinventarioVendedor: idinventarioVendedor ?? this.idinventarioVendedor,
      cantidad: cantidad ?? this.cantidad,
      porcentajeiva: porcentajeiva ?? this.porcentajeiva,
      idvendedor: idvendedor ?? this.idvendedor,
      nombrevendedor: nombrevendedor ?? this.nombrevendedor,
      idproducto: idproducto ?? this.idproducto,
      nombreproducto: nombreproducto ?? this.nombreproducto,
      precio: precio ?? this.precio,
      promocion: promocion ?? this.promocion,
    );
  }

  factory Inventario.fromJson(Map<String, dynamic> json) => Inventario(
      idinventarioVendedor: json["idinventarioVendedor"],
      cantidad: json["cantidad"],
      porcentajeiva: json["porcentajeiva"],
      idvendedor: json["idvendedor"],
      nombrevendedor: json["nombrevendedor"],
      idproducto: json["idproducto"],
      nombreproducto: json["nombreproducto"],
  );

  Map<String, dynamic> toJson() => {
      "idinventarioVendedor": idinventarioVendedor,
      "cantidad": cantidad,
      "porcentajeiva": porcentajeiva,
      "idvendedor": idvendedor,
      "nombrevendedor": nombrevendedor,
      "idproducto": idproducto,
      "nombreproducto": nombreproducto,
  };

  /// Convierte un JSON String que contiene un arreglo en List Inventario
  static List<Inventario> listFromJson(List<dynamic> jsonData) {
  return jsonData
      .map((item) => Inventario.fromJson(item as Map<String, dynamic>))
      .toList();
  }

  /// Convierte una lista de inventario a JSON String
  static List<Inventario> listToJson(List<Inventario> jsonList) {
      return jsonList
    .map((json) => Inventario.fromJson(json as Map<String, dynamic>))
    .toList();
  }

  factory Inventario.fromDetallePedido(Detallepedidovendedor detalle) {
    return Inventario(
      idinventarioVendedor: 0,
      cantidad: detalle.cantidad,
      porcentajeiva: 0,
      idvendedor: 0,
      nombrevendedor: '',
      idproducto: detalle.idproducto,
      nombreproducto: detalle.nombreproducto,
    );
  }
}
