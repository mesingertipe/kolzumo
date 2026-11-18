class Vendedor {
  final int idvendedor;
  final String nombre;
  final String consecutivoremision;
  final int idusuario;
  final String nombreusuario;
  final DateTime? fechaultimaventa;
  final String? mensaje;

  Vendedor({
      required this.idvendedor,
      required this.nombre,
      required this.consecutivoremision,
      required this.idusuario,
      required this.nombreusuario,
      required this.fechaultimaventa,
      required this.mensaje,
  });

  factory Vendedor.fromJson(Map<String, dynamic> json) => Vendedor(
      idvendedor: json["idvendedor"],
      nombre: json["nombre"],
      consecutivoremision: json["consecutivoremision"],
      idusuario: json["idusuario"],
      nombreusuario: json["nombreusuario"],
      fechaultimaventa: json["fechaultimaventa"],
      mensaje: json["mensaje"],
  );

  Map<String, dynamic> toJson() => {
      "idvendedor": idvendedor,
      "nombre": nombre,
      "consecutivoremision": consecutivoremision,
      "idusuario": idusuario,
      "nombreusuario": nombreusuario,
      "fechaultimaventa": fechaultimaventa,
      "mensaje": mensaje,
  };

  // Convierte un JSON String que contiene un arreglo en List Vendedor
  static List<Vendedor> listFromJson(List<dynamic> jsonData) {
  return jsonData
      .map((item) => Vendedor.fromJson(item as Map<String, dynamic>))
      .toList();
  }
}