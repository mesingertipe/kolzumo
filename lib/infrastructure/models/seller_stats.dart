class SellerStats {
  final int ventasRealizadas;
  final int clientesVisitados;
  final double efectivoRecibido;

  const SellerStats({
    required this.ventasRealizadas,
    required this.clientesVisitados,
    required this.efectivoRecibido,
  });

  factory SellerStats.empty() => const SellerStats(
    ventasRealizadas: 0,
    clientesVisitados: 0,
    efectivoRecibido: 0,
  );

  factory SellerStats.sample() => const SellerStats(
    ventasRealizadas: 14,
    clientesVisitados: 9,
    efectivoRecibido: 486000,
  );
}