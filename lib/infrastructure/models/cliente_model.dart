class Cliente {
    final int idcliente;
    final int idtipodocumento;
    final String nombretipodocumento;
    final String documento;
    final String nombreestablecimiento;
    final String direccion;
    final String telefono;
    final String email;
    final String administrador;
    final String barrio;
    final dynamic gps;
    final int consecutivoentrega;
    final int ivadiscrimina;
    final String iva;
    final int pagocredito;
    final String credito;
    final double cupo;
    final int plazo;
    final int estado;
    final String nombreestado;
    final int idcategoriaCliente;
    final String nombrecategoriaCliente;
    final int idruta;
    final String nombreruta;
    final int idciudad;
    final String nombreciudad;
    final String horariodesde;
    final String horariohasta;
    final DateTime horariodesdetime;
    final DateTime horariohastatime;
    final dynamic mensaje;

    Cliente({
        required this.idcliente,
        required this.idtipodocumento,
        required this.nombretipodocumento,
        required this.documento,
        required this.nombreestablecimiento,
        required this.direccion,
        required this.telefono,
        required this.email,
        required this.administrador,
        required this.barrio,
        required this.gps,
        required this.consecutivoentrega,
        required this.ivadiscrimina,
        required this.iva,
        required this.pagocredito,
        required this.credito,
        required this.cupo,
        required this.plazo,
        required this.estado,
        required this.nombreestado,
        required this.idcategoriaCliente,
        required this.nombrecategoriaCliente,
        required this.idruta,
        required this.nombreruta,
        required this.idciudad,
        required this.nombreciudad,
        required this.horariodesde,
        required this.horariohasta,
        required this.horariodesdetime,
        required this.horariohastatime,
        required this.mensaje,
    });

    factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        idcliente: json["idcliente"],
        idtipodocumento: json["idtipodocumento"],
        nombretipodocumento: json["nombretipodocumento"],
        documento: json["documento"],
        nombreestablecimiento: json["nombreestablecimiento"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        email: json["email"],
        administrador: json["administrador"],
        barrio: json["barrio"],
        gps: json["gps"],
        consecutivoentrega: json["consecutivoentrega"],
        ivadiscrimina: json["ivadiscrimina"],
        iva: json["iva"],
        pagocredito: json["pagocredito"],
        credito: json["credito"],
        cupo: json["cupo"],
        plazo: json["plazo"],
        estado: json["estado"],
        nombreestado: json["nombreestado"],
        idcategoriaCliente: json["idcategoriaCliente"],
        nombrecategoriaCliente: json["nombrecategoriaCliente"],
        idruta: json["idruta"],
        nombreruta: json["nombreruta"],
        idciudad: json["idciudad"],
        nombreciudad: json["nombreciudad"],
        horariodesde: json["horariodesde"],
        horariohasta: json["horariohasta"],
        horariodesdetime: DateTime.parse(json["horariodesdetime"]),
        horariohastatime: DateTime.parse(json["horariohastatime"]),
        mensaje: json["mensaje"],
    );

    Map<String, dynamic> toJson() => {
        "idcliente": idcliente,
        "idtipodocumento": idtipodocumento,
        "nombretipodocumento": nombretipodocumento,
        "documento": documento,
        "nombreestablecimiento": nombreestablecimiento,
        "direccion": direccion,
        "telefono": telefono,
        "email": email,
        "administrador": administrador,
        "barrio": barrio,
        "gps": gps,
        "consecutivoentrega": consecutivoentrega,
        "ivadiscrimina": ivadiscrimina,
        "iva": iva,
        "pagocredito": pagocredito,
        "credito": credito,
        "cupo": cupo,
        "plazo": plazo,
        "estado": estado,
        "nombreestado": nombreestado,
        "idcategoriaCliente": idcategoriaCliente,
        "nombrecategoriaCliente": nombrecategoriaCliente,
        "idruta": idruta,
        "nombreruta": nombreruta,
        "idciudad": idciudad,
        "nombreciudad": nombreciudad,
        "horariodesde": horariodesde,
        "horariohasta": horariohasta,
        "horariodesdetime": horariodesdetime.toIso8601String(),
        "horariohastatime": horariohastatime.toIso8601String(),
        "mensaje": mensaje,
    };

    /// Convierte un JSON String que contiene un arreglo en List Cliente
    static List<Cliente> listFromJson(List<dynamic> jsonData) {
    return jsonData
        .map((item) => Cliente.fromJson(item as Map<String, dynamic>))
        .toList();
    }

    /// Convierte una lista de clientes a JSON String
    static List<Cliente> listToJson(List<Cliente> jsonList) {
       return jsonList
      .map((json) => Cliente.fromJson(json as Map<String, dynamic>))
      .toList();
    }
}
