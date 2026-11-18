class Vehiculo {
    final int idvehiculo;
    final String tipovehiculo;
    final String placa;
    final dynamic mensaje;

    Vehiculo({
        required this.idvehiculo,
        required this.tipovehiculo,
        required this.placa,
        required this.mensaje,
    });

    factory Vehiculo.fromJson(Map<String, dynamic> json) => Vehiculo(
        idvehiculo: json["idvehiculo"],
        tipovehiculo: json["tipovehiculo"],
        placa: json["placa"],
        mensaje: json["mensaje"],
    );

    Map<String, dynamic> toJson() => {
        "idvehiculo": idvehiculo,
        "tipovehiculo": tipovehiculo,
        "placa": placa,
        "mensaje": mensaje,
    };

    /// Convierte un JSON String que contiene un arreglo en List Vehiculo
    static List<Vehiculo> listFromJson(List<dynamic> jsonData) {
    return jsonData
        .map((item) => Vehiculo.fromJson(item as Map<String, dynamic>))
        .toList();
    }

    /// Convierte una lista de vehiculos a JSON String
    static List<Vehiculo> listToJson(List<Vehiculo> jsonList) {
       return jsonList
      .map((json) => Vehiculo.fromJson(json as Map<String, dynamic>))
      .toList();
    }
}
