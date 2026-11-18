import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/models/seller_stats.dart';
import 'package:kolzumo_app/infrastructure/models/userauth.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../../controllers/day_closing_controller.dart';
import '../../../data/database/database.dart';
import '../../../logic/auth_logic.dart';
import 'daily_summary_sheet.dart';
import 'seller_stats_card.dart';

class ContentProfile extends StatelessWidget {
  const ContentProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // * Providers
    final database = context.read<AppDatabase>();
    UserAuth? user = context.watch<Auth>().userAccount;

    final streamCombinado = Rx.combineLatest2(
      database.ventasDao.watchVentasCount(),
      database.ventasDao.watchTotalEfectivoRecibido(),

      (int ventas, double efectivo) {
        return SellerStats(
          ventasRealizadas: ventas, 
          clientesVisitados: ventas, 
          efectivoRecibido: efectivo
        );
      }
    );

    return StreamBuilder<SellerStats>(
      stream: streamCombinado,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }

        if (snapshot.hasError) {
          return const Text('Error al cargar ventas');
        }

        final stats = snapshot.data ?? SellerStats(
          ventasRealizadas: 0, 
          clientesVisitados: 0, 
          efectivoRecibido: 0.0
        );

        if (user == null) {
          return const Center(child: Text('No hay datos de usuario activos.'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.46),
                child: Icon(
                  Icons.person,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.nombre,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.nombreperfil,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),
              
              SellerStatsCard(stats: stats),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _abrirFlujoFinalizarDia(context, stats),
                  icon: const Icon(Icons.summarize_outlined),
                  label: const Text('Ver resumen del día'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
    
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: const Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.email),
                      title: Text('Email'),
                      subtitle: Text('user_test@example.com'),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone'),
                      subtitle: Text('+1 555 123 4567'),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.location_on),
                      title: Text('Location'),
                      subtitle: Text('Medellín, Colombia'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'About',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Passionate about building mobile apps with clean and '
                        'maintainable code. Loves exploring Flutter and creating '
                        'intuitive user experiences.',
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

Future<void> _abrirFlujoFinalizarDia(BuildContext context, SellerStats stats) async {
  final cerrado = await showDailySummarySheet(context, stats: stats);

  if (!context.mounted) return;

  if (cerrado) {
    final mensaje = context.read<DayClosingController>().mensajeBackend;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje ?? 'Día finalizado con éxito'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}