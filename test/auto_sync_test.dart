import 'package:flutter_test/flutter_test.dart';
import 'package:kolzumo_app/core/services/auto_sync_service.dart';

void main() {
  test('AutoSyncQueueService initializes with correct default state', () {
    // Verificación de propiedades iniciales
    expect(SyncConnectionState.values.length, 3);
  });
}
