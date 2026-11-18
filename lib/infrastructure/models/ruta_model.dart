class Ruta {
    final int idruta;
    final String nombreruta;
    final int idzona;
    final String nombrezona;
    final int estado;
    final String nombreestado;
    final List<Diasvisita> diasvisita;
    final dynamic mensaje;

    Ruta({
        required this.idruta,
        required this.nombreruta,
        required this.idzona,
        required this.nombrezona,
        required this.estado,
        required this.nombreestado,
        required this.diasvisita,
        required this.mensaje,
    });

    factory Ruta.fromJson(Map<String, dynamic> json) => Ruta(
        idruta: json["idruta"],
        nombreruta: json["nombreruta"],
        idzona: json["idzona"],
        nombrezona: json["nombrezona"],
        estado: json["estado"],
        nombreestado: json["nombreestado"],
        diasvisita: List<Diasvisita>.from(json["diasvisita"].map((x) => Diasvisita.fromJson(x))),
        mensaje: json["mensaje"],
    );

    Map<String, dynamic> toJson() => {
        "idruta": idruta,
        "nombreruta": nombreruta,
        "idzona": idzona,
        "nombrezona": nombrezona,
        "estado": estado,
        "nombreestado": nombreestado,
        "diasvisita": List<dynamic>.from(diasvisita.map((x) => x.toJson())),
        "mensaje": mensaje,
    };

    /// Convierte un JSON String que contiene un arreglo en List Ruta
    static List<Ruta> listFromJson(List<dynamic> jsonData) {
    return jsonData
        .map((item) => Ruta.fromJson(item as Map<String, dynamic>))
        .toList();
    }

    /// Convierte una lista de rutas a JSON String
    static List<Ruta> listToJson(List<Ruta> jsonList) {
       return jsonList
      .map((json) => Ruta.fromJson(json as Map<String, dynamic>))
      .toList();
    }
}

class Diasvisita {
    final String nombre;
    final bool visitar;

    Diasvisita({
        required this.nombre,
        required this.visitar,
    });

    factory Diasvisita.fromJson(Map<String, dynamic> json) => Diasvisita(
        nombre: json["nombre"],
        visitar: json["visitar"],
    );

    Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "visitar": visitar,
    };
}
