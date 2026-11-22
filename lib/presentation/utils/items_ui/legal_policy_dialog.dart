import 'package:flutter/material.dart';
import 'package:kolzumo_app/config/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalPolicyHelper {
  LegalPolicyHelper._();

  static Future<void> openPrivacyPolicy(BuildContext context, String url) async {
    await _openDocument(
      context: context,
      title: 'Política de Privacidad',
      url: url,
      content: _privacyPolicyText,
    );
  }

  static Future<void> openTermsOfService(BuildContext context, String url) async {
    await _openDocument(
      context: context,
      title: 'Términos y Condiciones de Servicio',
      url: url,
      content: _termsOfServiceText,
    );
  }

  static Future<void> _openDocument({
    required BuildContext context,
    required String title,
    required String url,
    required String content,
  }) async {
    bool launched = false;
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}

    if (!launched && context.mounted) {
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => _LegalModalSheet(title: title, content: content, url: url),
      );
    }
  }

  static const String _privacyPolicyText = '''
POLÍTICA DE PRIVACIDAD — KOLZUMO S.A.S.
Última actualización: Noviembre 2026

1. IDENTIDAD DEL RESPONSABLE
KolZumo S.A.S., sociedad comercial colombiana domiciliada en Bogotá D.C., es la titular y responsable del tratamiento de los datos personales recolectados a través de la aplicación móvil KolZumo Móvil ("la Aplicación").

2. DATOS QUE RECOLECTAMOS Y FINALIDAD
- Datos de Autenticación: Identificación del vendedor, credenciales de acceso y verificación biométrica local (huella digital o Face ID, procesada exclusivamente en el hardware seguro del dispositivo, nunca transmitida a servidores externos).
- Datos Comerciales y Transaccionales: Facturas, comprobantes de pago (efectivo, transferencias Nequi/Daviplata/Bancolombia), pedidos y créditos concedidos a establecimientos de comercio clientes.
- Ubicación Satelital (GPS): La Aplicación captura coordenadas GPS en primer plano en momentos operacionales específicos: al confirmar ventas y al formalizar el Cierre de Jornada (Cuadre de Caja). Esto se realiza para certificar la visita comercial en ruta y prevenir fraudes o descuadres de inventario.
- Permisos Bluetooth: Utilizados exclusivamente para el enlace y transmisión de datos a impresoras térmicas portátiles ESC/POS homologadas (58mm/80mm).

3. SEGURIDAD Y PRIVACIDAD OFFLINE-FIRST
La Aplicación procesa información de manera local en una base de datos segura cifrada en el dispositivo (Drift SQLite). La transmisión hacia el backend de KolZumo se efectúa mediante protocolos seguros HTTPS/TLS.

4. DERECHOS DEL TITULAR (LEY 1581 DE 2012)
Cualquier usuario o titular puede consultar, actualizar, rectificar o solicitar la supresión de sus datos personales a través del canal oficial: sistemas@kolzumo.com.co o en la sede principal de KolZumo S.A.S.
''';

  static const String _termsOfServiceText = '''
TÉRMINOS Y CONDICIONES DE SERVICIO — KOLZUMO MÓVIL
Última actualización: Noviembre 2026

1. OBJETO Y ALCANCE
Los presentes Términos regulan el uso de la Aplicación KolZumo Móvil desarrollada para la gestión operativa de preventa, autoventa, facturación térmica y cuadre de caja de distribución en ruta.

2. USUARIOS AUTORIZADOS
El uso de la aplicación está restringido exclusivamente a colaboradores, vendedores de ruta, conductores repartidores y personal operativo autorizado de KolZumo S.A.S. o sus distribuidores oficiales.

3. CUSTODIA DE PRODUCTOS Y VALORES
- El usuario asume la responsabilidad del cotejo físico de las referencias asignadas en furgón al pulsar "Aceptar Inventario".
- Todos los recaudos en efectivo y soportes de transferencias electrónicas deberán coincidir peso por peso con la tirilla final de Cuadre de Caja (Reporte Z) para la liquidación formal en tesorería.

4. INTEGRIDAD DE LAS TRANSACCIONES
Toda factura generada posee carácter oficial y no podrá ser anulada ni modificada sin la autorización expresa del área de operaciones y auditoría comercial.

5. PROPIEDAD INTELECTUAL
El software, interfaces, marcas, logos y algoritmos de facturación son propiedad exclusiva de KolZumo S.A.S.
''';
}

class _LegalModalSheet extends StatelessWidget {
  final String title;
  final String content;
  final String url;

  const _LegalModalSheet({
    required this.title,
    required this.content,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.forestDark,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.all(18),
                  child: SelectableText(
                    content,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.open_in_browser_rounded),
                      label: const Text('Abrir en el Navegador Web'),
                      onPressed: () async {
                        try {
                          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                        } catch (_) {}
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
