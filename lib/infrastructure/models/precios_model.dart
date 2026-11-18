class Precios {
    final int idprecio;
    final int idproducto;
    final String nombreproducto;
    final int idcategoriacliente;
    final String categoriacliente;
    final double valor;
    final dynamic mensaje;

    Precios({
        required this.idprecio,
        required this.idproducto,
        required this.nombreproducto,
        required this.idcategoriacliente,
        required this.categoriacliente,
        required this.valor,
        required this.mensaje,
    });

    factory Precios.fromJson(Map<String, dynamic> json) => Precios(
        idprecio: json["idprecio"],
        idproducto: json["idproducto"],
        nombreproducto: json["nombreproducto"],
        idcategoriacliente: json["idcategoriacliente"],
        categoriacliente: json["categoriacliente"],
        valor: json["valor"],
        mensaje: json["mensaje"],
    );

    Map<String, dynamic> toJson() => {
        "idprecio": idprecio,
        "idproducto": idproducto,
        "nombreproducto": nombreproducto,
        "idcategoriacliente": idcategoriacliente,
        "categoriacliente": categoriacliente,
        "valor": valor,
        "mensaje": mensaje,
    };

    /// Convierte un JSON String que contiene un arreglo en List Precios
    static List<Precios> listFromJson(List<dynamic> jsonData) {
    return jsonData
        .map((item) => Precios.fromJson(item as Map<String, dynamic>))
        .toList();
    }

    /// Convierte una lista de rutas a JSON String
    static List<Precios> listToJson(List<Precios> jsonList) {
       return jsonList
      .map((json) => Precios.fromJson(json as Map<String, dynamic>))
      .toList();
    }
}
