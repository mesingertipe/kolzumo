import '../models/promocion_model.dart';

class PromocionHelper {
  static int calcularConsumoStock(
    Promocion? promocion,
    int cantidadVenta,
  ) {
    if (promocion == null || promocion.cantidadventa <= 0 || cantidadVenta < promocion.cantidadventa) return cantidadVenta;
    

    int bonificacion = 0;

    if (cantidadVenta >= promocion.cantidadventa) {
      final veces = cantidadVenta ~/ promocion.cantidadventa;

      // Promoción por cantidad
      if ((promocion.cantidadsobreventa ?? 0) > 0) {
        bonificacion = veces * promocion.cantidadsobreventa!;
      }

      // Promoción por porcentaje
      else if ((promocion.porcentajesobreventa ?? 0) > 0) {
        final bonificacionPorBloque = (promocion.cantidadventa * promocion.porcentajesobreventa! / 100).floor();

        bonificacion = veces * bonificacionPorBloque;
      }
    }

    return cantidadVenta + bonificacion;
  }

  static int calcularBonificacion(
    Promocion? promocion,
    int cantidadVenta,
  ) {
      return calcularConsumoStock(promocion, cantidadVenta) - cantidadVenta;
  }
}