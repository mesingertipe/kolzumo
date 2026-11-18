import 'package:location/location.dart';

Future<LocationData?> obtenerUbicacion() async {
  final location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;

  // Verifica si el GPS está activado
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return Future.error('El servicio de ubicación está deshabilitado.');
    }
  }

  // Verifica permisos
  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return Future.error('Permisos de ubicación denegados.');
    }
  }

  if (permissionGranted == PermissionStatus.deniedForever) {
    return Future.error(
      'Permisos de ubicación denegados permanentemente, no se puede solicitar.',
    );
  }

  // Ya con permisos, obtiene la ubicación actual
  return await location.getLocation();
}