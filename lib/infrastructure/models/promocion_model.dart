import 'cliente_model.dart';

class Promocion {
    final int idpromocion;
    final String promocionpara;
    final String promocionde;
    final int cantidadventa;
    final int? cantidadsobreventa;
    final int? porcentajesobreventa;
    final DateTime fechadesde;
    final DateTime fechahasta;
    final DateTime? fechadesdetxt;
    final DateTime? fechahastatxt;
    final int idproducto;
    final String producto;
    final int? idpromocionruta;
    final String? nombrepromocionruta;
    final int? idpromocioncatcli;
    final String? nombrepromocioncatcli;
    final List<Listaclientespromocion> listaclientespromocion;
    final String? mensaje;

    Promocion({
        required this.idpromocion,
        required this.promocionpara,
        required this.promocionde,
        required this.cantidadventa,
        required this.cantidadsobreventa,
        required this.porcentajesobreventa,
        required this.fechadesde,
        required this.fechahasta,
        this.fechadesdetxt,
        this.fechahastatxt,
        required this.idproducto,
        required this.producto,
        required this.idpromocionruta,
        required this.nombrepromocionruta,
        required this.idpromocioncatcli,
        required this.nombrepromocioncatcli,
        required this.listaclientespromocion,
        this.mensaje,
    });

    factory Promocion.fromJson(Map<String, dynamic> json) => Promocion(
        idpromocion: json["idpromocion"],
        promocionpara: json["promocionpara"],
        promocionde: json["promocionde"],
        cantidadventa: json["cantidadventa"],
        cantidadsobreventa: json["cantidadsobreventa"],
        porcentajesobreventa: json["porcentajesobreventa"],
        fechadesde: DateTime.parse(json["fechadesde"]),
        fechahasta: DateTime.parse(json["fechahasta"]),
        fechadesdetxt: DateTime.parse(json["fechadesdetxt"]),
        fechahastatxt: DateTime.parse(json["fechahastatxt"]),
        idproducto: json["idproducto"],
        producto: json["producto"],
        idpromocionruta: json["idpromocionruta"],
        nombrepromocionruta: json["nombrepromocionruta"],
        idpromocioncatcli: json["idpromocioncatcli"],
        nombrepromocioncatcli: json["nombrepromocioncatcli"],
        listaclientespromocion: (json["listaclientespromocion"] as List<dynamic>? ?? [])
            .map((e) => Listaclientespromocion.fromJson(e as Map<String, dynamic>))
            .toList(),
        mensaje: json["mensaje"],
    );

    Map<String, dynamic> toJson() => {
        "idpromocion": idpromocion,
        "promocionpara": promocionpara,
        "promocionde": promocionde,
        "cantidadventa": cantidadventa,
        "cantidadsobreventa": cantidadsobreventa,
        "porcentajesobreventa": porcentajesobreventa,
        "fechadesde": "${fechadesde.year.toString().padLeft(4, '0')}-${fechadesde.month.toString().padLeft(2, '0')}-${fechadesde.day.toString().padLeft(2, '0')}",
        "fechahasta": "${fechahasta.year.toString().padLeft(4, '0')}-${fechahasta.month.toString().padLeft(2, '0')}-${fechahasta.day.toString().padLeft(2, '0')}",
        "fechadesdetxt": "${fechadesdetxt!.year.toString().padLeft(4, '0')}-${fechadesdetxt!.month.toString().padLeft(2, '0')}-${fechadesdetxt!.day.toString().padLeft(2, '0')}",
        "fechahastatxt": "${fechahastatxt!.year.toString().padLeft(4, '0')}-${fechahastatxt!.month.toString().padLeft(2, '0')}-${fechahastatxt!.day.toString().padLeft(2, '0')}",
        "idproducto": idproducto,
        "producto": producto,
        "idpromocionruta": idpromocionruta,
        "nombrepromocionruta": nombrepromocionruta,
        "idpromocioncatcli": idpromocioncatcli,
        "nombrepromocioncatcli": nombrepromocioncatcli,
        "listaclientespromocion": listaclientespromocion.map((e) => e.toJson()).toList(),
        "mensaje": mensaje,
    };

    /// Convierte un JSON String que contiene un arreglo en List Promocion
    static List<Promocion> listFromJson(List<dynamic> jsonData) {
    return jsonData
        .map((item) => Promocion.fromJson(item as Map<String, dynamic>))
        .toList();
    }

    /// Convierte una lista de promocion a JSON String
    static List<Promocion> listToJson(List<Promocion> jsonList) {
        return jsonList
      .map((json) => Promocion.fromJson(json as Map<String, dynamic>))
      .toList();
    }
}

class Listaclientespromocion {
    final int idclientePromocion;
    final int idcliente;
    final String nombrecliente;
    final int idpromocion;
    final String promocionde;
    final DateTime fechadesde;
    final DateTime fechahasta;
    final String producto;
    final dynamic mensaje;

    Listaclientespromocion({
        required this.idclientePromocion,
        required this.idcliente,
        required this.nombrecliente,
        required this.idpromocion,
        required this.promocionde,
        required this.fechadesde,
        required this.fechahasta,
        required this.producto,
        required this.mensaje,
    });

    factory Listaclientespromocion.fromJson(Map<String, dynamic> json) => Listaclientespromocion(
        idclientePromocion: json["idclientePromocion"],
        idcliente: json["idcliente"],
        nombrecliente: json["nombrecliente"],
        idpromocion: json["idpromocion"],
        promocionde: json["promocionde"],
        fechadesde: DateTime.parse(json["fechadesde"]),
        fechahasta: DateTime.parse(json["fechahasta"]),
        producto: json["producto"],
        mensaje: json["mensaje"],
    );

    Map<String, dynamic> toJson() => {
        "idclientePromocion": idclientePromocion,
        "idcliente": idcliente,
        "nombrecliente": nombrecliente,
        "idpromocion": idpromocion,
        "promocionde": promocionde,
        "fechadesde": "${fechadesde.year.toString().padLeft(4, '0')}-${fechadesde.month.toString().padLeft(2, '0')}-${fechadesde.day.toString().padLeft(2, '0')}",
        "fechahasta": "${fechahasta.year.toString().padLeft(4, '0')}-${fechahasta.month.toString().padLeft(2, '0')}-${fechahasta.day.toString().padLeft(2, '0')}",
        "producto": producto,
        "mensaje": mensaje,
    };
}

extension PromocionExtension on Promocion {
  bool aplicaPara(Cliente cliente) {
    return (nombrepromocionruta != null && nombrepromocionruta == cliente.nombreruta) ||
        (idpromocioncatcli != null && idpromocioncatcli == cliente.idcategoriaCliente) ||
        listaclientespromocion.any(
          (p) => p.nombrecliente == cliente.nombreestablecimiento,
        );
  }
}