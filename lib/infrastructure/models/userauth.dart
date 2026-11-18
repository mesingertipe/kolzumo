class UserAuth {
    final int idusuario;
    final String nombre;
    final dynamic documento;
    final dynamic direccion;
    final dynamic telefono;
    final dynamic email;
    final String clave;
    final int idperfil;
    final String nombreperfil;
    final int estado;
    final String nombreestado;
    final DateTime fechaestado;
    final String mensaje;
    final bool autorizado;
    final int idvendedor;

    UserAuth({
        required this.idusuario,
        required this.nombre,
        required this.documento,
        required this.direccion,
        required this.telefono,
        required this.email,
        required this.clave,
        required this.idperfil,
        required this.nombreperfil,
        required this.estado,
        required this.nombreestado,
        required this.fechaestado,
        required this.mensaje,
        required this.autorizado,
        required this.idvendedor,
    });

    factory UserAuth.fromJson(Map<String, dynamic> json) => UserAuth(
        idusuario: json["idusuario"],
        nombre: json["nombre"],
        documento: json["documento"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        email: json["email"],
        clave: json["clave"],
        idperfil: json["idperfil"],
        nombreperfil: json["nombreperfil"],
        estado: json["estado"],
        nombreestado: json["nombreestado"],
        fechaestado: DateTime.parse(json["fechaestado"]),
        mensaje: json["mensaje"],
        autorizado: json["autorizado"],
        idvendedor: json["idvendedor"],
    );

    Map<String, dynamic> toJson() => {
        "idusuario": idusuario,
        "nombre": nombre,
        "documento": documento,
        "direccion": direccion,
        "telefono": telefono,
        "email": email,
        "clave": clave,
        "idperfil": idperfil,
        "nombreperfil": nombreperfil,
        "estado": estado,
        "nombreestado": nombreestado,
        "fechaestado": "${fechaestado.year.toString().padLeft(4, '0')}-${fechaestado.month.toString().padLeft(2, '0')}-${fechaestado.day.toString().padLeft(2, '0')}",
        "mensaje": mensaje,
        "autorizado": autorizado,
        "idvendedor": idvendedor,
    };
}
