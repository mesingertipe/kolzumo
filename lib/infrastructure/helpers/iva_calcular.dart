class IvaCalculator {
  static double calcular({required double subtotal, required int porcentajeIva}) {
    return subtotal * (porcentajeIva / 100);
  }
}