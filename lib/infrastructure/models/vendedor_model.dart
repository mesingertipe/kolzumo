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

  factory Vendedor.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    final rawDate = json["fechaultimaventa"];
    if (rawDate is DateTime) {
      parsedDate = rawDate;
    } else if (rawDate is String && rawDate.isNotEmpty) {
      parsedDate = DateTime.tryParse(rawDate);
    }

    return Vendedor(
      idvendedor: json["idvendedor"] ?? 0,
      nombre: (json["nombre"] ?? '').toString(),
      consecutivoremision: (json["consecutivoremision"] ?? '').toString(),
      idusuario: json["idusuario"] ?? 0,
      nombreusuario: (json["nombreusuario"] ?? '').toString(),
      fechaultimaventa: parsedDate,
      mensaje: json["mensaje"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "idvendedor": idvendedor,
        "nombre": nombre,
        "consecutivoremision": consecutivoremision,
        "idusuario": idusuario,
        "nombreusuario": nombreusuario,
        "fechaultimaventa": fechaultimaventa?.toIso8601String(),
        "mensaje": mensaje,
      };

  /// Extrae dinámicamente el prefijo alfanumérico y el número secuencial
  /// enviado por el backend (ej. "PPP30002" -> prefix: "PPP", number: 30002, padWidth: 5)
  /// sin quemar ningún prefijo en el código.
  ({String prefix, int number, int padWidth}) parseConsecutivo() {
    final raw = consecutivoremision.trim();
    final match = RegExp(r'^([^0-9]*)([0-9]+)$').firstMatch(raw);
    if (match != null) {
      final prefix = match.group(1) ?? '';
      final digits = match.group(2) ?? '1';
      return (
        prefix: prefix,
        number: int.tryParse(digits) ?? 1,
        padWidth: digits.length,
      );
    }
    if (raw.length > 3) {
      final prefix = raw.substring(0, 3);
      final digits = raw.substring(3).replaceAll(RegExp(r'[^0-9]'), '');
      return (
        prefix: prefix,
        number: int.tryParse(digits) ?? 1,
        padWidth: digits.isNotEmpty ? digits.length : 4,
      );
    }
    return (prefix: '', number: 1, padWidth: 4);
  }

  static List<Vendedor> listFromJson(List<dynamic> jsonData) {
    return jsonData
        .map((item) => Vendedor.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
