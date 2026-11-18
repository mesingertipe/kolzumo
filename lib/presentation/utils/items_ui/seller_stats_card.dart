import 'package:flutter/material.dart';
import '../../../infrastructure/models/seller_stats.dart';

class SellerStatsCard extends StatelessWidget {
  const SellerStatsCard({super.key, required this.stats});

  final SellerStats stats;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatItem(
              icon: Icons.point_of_sale,
              value: '${stats.ventasRealizadas}',
              label: 'Ventas',
            ),
            _VerticalDivider(),
            _StatItem(
              icon: Icons.groups,
              value: '${stats.clientesVisitados}',
              label: 'Visitados',
            ),
            _VerticalDivider(),
            _StatItem(
              icon: Icons.payments,
              value: _formatCurrency(stats.efectivoRecibido),
              label: 'Efectivo',
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '\$${(value / 1000)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: primary, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Colors.grey.withValues(alpha: 0.25),
    );
  }
}