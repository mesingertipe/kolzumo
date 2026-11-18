class PedidosPendientes {
    final int idpedidovendedor;
    final DateTime fechapedido;
    final int estado;
    final String nombreestado;
    final int idbodega;
    final dynamic nombrebodega;
    final int idvendedor;
    final dynamic nombrevendedor;
    final List<Detallepedidovendedor> detallepedidovendedor;
    final dynamic mensaje;

    PedidosPendientes({
        required this.idpedidovendedor,
        required this.fechapedido,
        required this.estado,
        required this.nombreestado,
        required this.idbodega,
        required this.nombrebodega,
        required this.idvendedor,
        required this.nombrevendedor,
        required this.detallepedidovendedor,
        required this.mensaje,
    });

    factory PedidosPendientes.fromJson(Map<String, dynamic> json) => PedidosPendientes(
        idpedidovendedor: json["idpedidovendedor"],
        fechapedido: DateTime.parse(json["fechapedido"]),
        estado: json["estado"],
        nombreestado: json["nombreestado"],
        idbodega: json["idbodega"],
        nombrebodega: json["nombrebodega"],
        idvendedor: json["idvendedor"],
        nombrevendedor: json["nombrevendedor"],
        detallepedidovendedor: List<Detallepedidovendedor>.from(json["detallepedidovendedor"].map((x) => Detallepedidovendedor.fromJson(x))),
        mensaje: json["mensaje"],
    );

    Map<String, dynamic> toJson() => {
        "idpedidovendedor": idpedidovendedor,
        "fechapedido": fechapedido.toIso8601String(),
        "estado": estado,
        "nombreestado": nombreestado,
        "idbodega": idbodega,
        "nombrebodega": nombrebodega,
        "idvendedor": idvendedor,
        "nombrevendedor": nombrevendedor,
        "detallepedidovendedor": List<dynamic>.from(detallepedidovendedor.map((x) => x.toJson())),
        "mensaje": mensaje,
    };

    /// Convierte un JSON String que contiene un arreglo en List PedidosPendientes
    static List<PedidosPendientes> listFromJson(List<dynamic> jsonData) {
    return jsonData
        .map((item) => PedidosPendientes.fromJson(item as Map<String, dynamic>))
        .toList();
    }

    /// Convierte una lista de pedidospendientes a JSON String
    static List<PedidosPendientes> listToJson(List<PedidosPendientes> jsonList) {
       return jsonList
      .map((json) => PedidosPendientes.fromJson(json as Map<String, dynamic>))
      .toList();
    }
}

class Detallepedidovendedor {
    final int iddetallepedidovendedor;
    final int idproducto;
    final String nombreproducto;
    final int cantidad;
    final int idpedidovendedor;

    Detallepedidovendedor({
        required this.iddetallepedidovendedor,
        required this.idproducto,
        required this.nombreproducto,
        required this.cantidad,
        required this.idpedidovendedor,
    });

    factory Detallepedidovendedor.fromJson(Map<String, dynamic> json) => Detallepedidovendedor(
        iddetallepedidovendedor: json["iddetallepedidovendedor"],
        idproducto: json["idproducto"],
        nombreproducto: json["nombreproducto"],
        cantidad: json["cantidad"],
        idpedidovendedor: json["idpedidovendedor"],
    );

    Map<String, dynamic> toJson() => {
        "iddetallepedidovendedor": iddetallepedidovendedor,
        "idproducto": idproducto,
        "nombreproducto": nombreproducto,
        "cantidad": cantidad,
        "idpedidovendedor": idpedidovendedor,
    };
}
