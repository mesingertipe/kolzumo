class ResultadoSincronizacion {
  final bool exitoso;
  final int totalProductos;
  final String? error;

  ResultadoSincronizacion.ok(this.totalProductos)
      : exitoso = true,
        error = null;

  ResultadoSincronizacion.fallo(this.error)
      : exitoso = false,
        totalProductos = 0;
}