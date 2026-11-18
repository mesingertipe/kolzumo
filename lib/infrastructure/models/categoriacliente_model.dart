class CategoriaCliente {
  final int idcategoriaCliente;
  final String nombre;

  CategoriaCliente({
      required this.idcategoriaCliente,
      required this.nombre,
  });

  factory CategoriaCliente.fromJson(Map<String, dynamic> json) => CategoriaCliente(
      idcategoriaCliente: json["idcategoriaCliente"],
      nombre: json["nombre"],
  );

  Map<String, dynamic> toJson() => {
      "idcategoriaCliente": idcategoriaCliente,
      "nombre": nombre,
  };

  /// Convierte un JSON String que contiene un arreglo en List Cliente
  static List<CategoriaCliente> listFromJson(List<dynamic> jsonData) {
  return jsonData
      .map((item) => CategoriaCliente.fromJson(item as Map<String, dynamic>))
      .toList();
  }

  /// Convierte una lista de categoriacliente a JSON String
  static List<CategoriaCliente> listToJson(List<CategoriaCliente> jsonList) {
      return jsonList
    .map((json) => CategoriaCliente.fromJson(json as Map<String, dynamic>))
    .toList();
  }
}
