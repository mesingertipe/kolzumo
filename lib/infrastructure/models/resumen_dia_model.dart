import 'package:kolzumo_app/data/database/daos/ventas_dao.dart';
import 'package:kolzumo_app/infrastructure/models/inventario_model.dart';

class ResumenDia {
  final int idresumenvendedordia;
  final int idvendedor;
  final String nombrevendedor;
  final DateTime fecha;
  final List<VentaCompleta> listaventas;
  final List<Inventario> listainventario;
  final String? mensaje;

  ResumenDia({
      required this.idresumenvendedordia,
      required this.idvendedor,
      required this.nombrevendedor,
      required this.fecha,
      required this.listaventas,
      required this.listainventario,
      this.mensaje,
  });

  Map<String, dynamic> toJson() {
    return {
      'idresumenvendedordia': idresumenvendedordia,
      'idvendedor': idvendedor,
      'nombrevendedor': nombrevendedor,
      'fecha': fecha.toIso8601String(),
      'listaventas': listaventas.map((v) => v.toJson()).toList(),
      'listainventario': listainventario.map((i) => i.toJson()).toList(),
      'mensaje': mensaje,
    };
  }

}

