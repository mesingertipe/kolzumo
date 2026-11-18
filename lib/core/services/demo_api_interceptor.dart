import 'package:dio/dio.dart';

/// Interceptor de Modo Demo / Usuario Dummy (`demo` / `1234`).
/// Permite probar el 100% del flujo de la aplicación en cualquier celular
/// (Login, Biometría, Pedidos Pendientes, Iniciar Día, Rutas Codito y Suba Oriental,
/// Clientes con y sin Crédito, Carrito, Pagos Mixtos, Tirillas PPP30002 y Cuadre de Caja)
/// sin depender de conexión al servidor backend.
class DemoApiInterceptor extends Interceptor {
  DemoApiInterceptor._();
  static final DemoApiInterceptor instance = DemoApiInterceptor._();

  static const int demoVendedorId = 999;
  static const String demoUsername = 'demo';
  static const String demoPassword = '1234';

  bool isDemoMode = false;
  bool _demoOrderApproved = false;

  void activateDemoMode() {
    isDemoMode = true;
  }

  void deactivateDemoMode() {
    isDemoMode = false;
    _demoOrderApproved = false;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final path = options.path;

    // 1. Intercepta login cuando el usuario es "demo"
    if (path.contains('/usuarios/validarusuario')) {
      final data = options.data;
      final username = (data is Map ? data['nombre'] : '')
          .toString()
          .trim()
          .toLowerCase();

      if (username == demoUsername) {
        isDemoMode = true;
        return handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {
              'idusuario': 999,
              'nombre': 'Pepito Perez (Demo)',
              'documento': '1020304050',
              'direccion': 'Zona Industrial KolZumo - Bogotá',
              'telefono': '300 456 7890',
              'email': 'vendedor.demo@kolzumo.co',
              'clave': demoPassword,
              'idperfil': 5,
              'nombreperfil': 'Vendedor en Ruta',
              'estado': 1,
              'nombreestado': 'Activo',
              'fechaestado': DateTime.now().toIso8601String().split('T')[0],
              'mensaje': 'Usuario demo autorizado',
              'autorizado': true,
              'idvendedor': demoVendedorId,
            },
          ),
        );
      } else {
        isDemoMode = false;
      }
    }

    if (!isDemoMode) {
      return handler.next(options);
    }

    // 2. Respuestas simuladas para todos los endpoints cuando isDemoMode == true
    final nowStr = DateTime.now().toIso8601String();
    final todayStr = nowStr.split('T')[0];

    if (path.contains('/app/verpedidosvendedor')) {
      if (_demoOrderApproved) {
        return handler.resolve(
          Response(requestOptions: options, statusCode: 200, data: []),
        );
      }
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: [
            {
              'idpedidovendedor': 101,
              'fechapedido': todayStr,
              'estado': 1,
              'nombreestado': 'Pendiente Aprobación',
              'idbodega': 1,
              'nombrebodega': 'Bodega Principal',
              'idvendedor': demoVendedorId,
              'nombrevendedor': 'Pepito Perez (Demo)',
              'mensaje': null,
              'detallepedidovendedor': [
                {
                  'iddetallepedidovendedor': 1,
                  'idproducto': 1,
                  'nombreproducto': 'Concentrado de limón 375 ml',
                  'cantidad': 34,
                  'idpedidovendedor': 101,
                },
                {
                  'iddetallepedidovendedor': 2,
                  'idproducto': 2,
                  'nombreproducto': 'Concentrado de Limón 1100 ml',
                  'cantidad': 25,
                  'idpedidovendedor': 101,
                },
                {
                  'iddetallepedidovendedor': 3,
                  'idproducto': 3,
                  'nombreproducto': 'Concentrado de Coco 375 ml',
                  'cantidad': 30,
                  'idpedidovendedor': 101,
                },
                {
                  'iddetallepedidovendedor': 4,
                  'idproducto': 4,
                  'nombreproducto': 'Concentrado de Maracuyá 375 ml',
                  'cantidad': 35,
                  'idpedidovendedor': 101,
                },
              ],
            },
          ],
        ),
      );
    }

    if (path.contains('/app/aprobarpedido')) {
      _demoOrderApproved = true;
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'mensaje': 'Pedido aprobado correctamente'},
        ),
      );
    }

    if (path.contains('/app/verinventariovendedor')) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: [
            {
              'idinventarioVendedor': 1,
              'cantidad': 34,
              'porcentajeiva': 0,
              'idvendedor': demoVendedorId,
              'nombrevendedor': 'Pepito Perez (Demo)',
              'idproducto': 1,
              'nombreproducto': 'Concentrado de limón 375 ml',
            },
            {
              'idinventarioVendedor': 2,
              'cantidad': 25,
              'porcentajeiva': 0,
              'idvendedor': demoVendedorId,
              'nombrevendedor': 'Pepito Perez (Demo)',
              'idproducto': 2,
              'nombreproducto': 'Concentrado de Limón 1100 ml',
            },
            {
              'idinventarioVendedor': 3,
              'cantidad': 30,
              'porcentajeiva': 0,
              'idvendedor': demoVendedorId,
              'nombrevendedor': 'Pepito Perez (Demo)',
              'idproducto': 3,
              'nombreproducto': 'Concentrado de Coco 375 ml',
            },
            {
              'idinventarioVendedor': 4,
              'cantidad': 35,
              'porcentajeiva': 0,
              'idvendedor': demoVendedorId,
              'nombrevendedor': 'Pepito Perez (Demo)',
              'idproducto': 4,
              'nombreproducto': 'Concentrado de Maracuyá 375 ml',
            },
          ],
        ),
      );
    }

    if (path.contains('/tbasicas/verrutas')) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: [
            {
              'idruta': 1,
              'nombreruta': 'Codito',
              'idzona': 1,
              'nombrezona': 'Zona Norte',
              'estado': 1,
              'nombreestado': 'Activo',
              'diasvisita': [
                {'nombre': 'Lunes', 'visitar': true},
                {'nombre': 'Miércoles', 'visitar': true},
              ],
              'mensaje': null,
            },
            {
              'idruta': 2,
              'nombreruta': 'Suba Oriental',
              'idzona': 2,
              'nombrezona': 'Zona Suba',
              'estado': 1,
              'nombreestado': 'Activo',
              'diasvisita': [
                {'nombre': 'Martes', 'visitar': true},
                {'nombre': 'Jueves', 'visitar': true},
              ],
              'mensaje': null,
            },
          ],
        ),
      );
    }

    if (path.contains('/tbasicas/vervehiculos')) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: [
            {
              'idvehiculo': 1,
              'tipovehiculo': 'Furgón Reparto',
              'placa': 'VOX 234',
              'mensaje': null,
            },
            {
              'idvehiculo': 2,
              'tipovehiculo': 'Camión NHR',
              'placa': 'KZM 101',
              'mensaje': null,
            },
          ],
        ),
      );
    }

    if (path.contains('/tbasicas/vercategoriascliente')) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: [
            {'idcategoriaCliente': 1, 'nombre': 'Supermercado'},
            {'idcategoriaCliente': 2, 'nombre': 'Mayorista'},
          ],
        ),
      );
    }

    if (path.contains('/tbasicas/verclientes')) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: [
            {
              'idcliente': 3,
              'idtipodocumento': 1,
              'nombretipodocumento': 'NIT',
              'documento': '900456123-1',
              'nombreestablecimiento': 'MetroWilfo',
              'direccion': 'Marsella Antigua Cl 10 68 27',
              'telefono': '310 555 1234',
              'email': 'compras@metrowilfo.co',
              'administrador': 'Wilmar Forero',
              'barrio': 'Marsella',
              'gps': '4.6321, -74.1190',
              'consecutivoentrega': 1,
              'ivadiscrimina': 0,
              'iva': 'No',
              'pagocredito': 1,
              'credito': 'Si',
              'cupo': 500000.0,
              'plazo': 15,
              'estado': 1,
              'nombreestado': 'Activo',
              'idcategoriaCliente': 1,
              'nombrecategoriaCliente': 'Supermercado',
              'idruta': 1,
              'nombreruta': 'Codito',
              'idciudad': 1,
              'nombreciudad': 'Bogotá',
              'horariodesde': '07:00',
              'horariohasta': '18:00',
              'horariodesdetime': nowStr,
              'horariohastatime': nowStr,
              'mensaje': null,
            },
            {
              'idcliente': 1,
              'idtipodocumento': 1,
              'nombretipodocumento': 'NIT',
              'documento': '800987654-3',
              'nombreestablecimiento': 'Unimercast',
              'direccion': 'Marsella Call 8 69d 12',
              'telefono': '315 222 3344',
              'email': 'contacto@unimercast.co',
              'administrador': 'Carlos Gómez',
              'barrio': 'Suba',
              'gps': '4.7410, -74.0840',
              'consecutivoentrega': 2,
              'ivadiscrimina': 0,
              'iva': 'No',
              'pagocredito': 0,
              'credito': 'No',
              'cupo': 0.0,
              'plazo': 0,
              'estado': 1,
              'nombreestado': 'Activo',
              'idcategoriaCliente': 1,
              'nombrecategoriaCliente': 'Supermercado',
              'idruta': 2,
              'nombreruta': 'Suba Oriental',
              'idciudad': 1,
              'nombreciudad': 'Bogotá',
              'horariodesde': '08:00',
              'horariohasta': '19:00',
              'horariodesdetime': nowStr,
              'horariohastatime': nowStr,
              'mensaje': null,
            },
            {
              'idcliente': 2,
              'idtipodocumento': 1,
              'nombretipodocumento': 'NIT',
              'documento': '901222333-9',
              'nombreestablecimiento': 'Mercast',
              'direccion': 'Marsella Calle 8 69 12',
              'telefono': '320 888 9900',
              'email': 'gerencia@mercast.co',
              'administrador': 'José Alberto Pérez',
              'barrio': 'Suba',
              'gps': '4.7420, -74.0850',
              'consecutivoentrega': 3,
              'ivadiscrimina': 0,
              'iva': 'No',
              'pagocredito': 1,
              'credito': 'Si',
              'cupo': 350000.0,
              'plazo': 30,
              'estado': 1,
              'nombreestado': 'Activo',
              'idcategoriaCliente': 2,
              'nombrecategoriaCliente': 'Mayorista',
              'idruta': 2,
              'nombreruta': 'Suba Oriental',
              'idciudad': 1,
              'nombreciudad': 'Bogotá',
              'horariodesde': '07:30',
              'horariohasta': '17:30',
              'horariodesdetime': nowStr,
              'horariohastatime': nowStr,
              'mensaje': null,
            },
          ],
        ),
      );
    }

    if (path.contains('/tbasicas/verprecios')) {
      final productos = [
        (id: 1, nombre: 'Concentrado de limón 375 ml', precio: 2100.0),
        (id: 2, nombre: 'Concentrado de Limón 1100 ml', precio: 5000.0),
        (id: 3, nombre: 'Concentrado de Coco 375 ml', precio: 2000.0),
        (id: 4, nombre: 'Concentrado de Maracuyá 375 ml', precio: 2000.0),
      ];
      final categorias = [
        (id: 1, nombre: 'Supermercado'),
        (id: 2, nombre: 'Mayorista'),
      ];

      int idPrecio = 1;
      final data = <Map<String, dynamic>>[];
      for (final cat in categorias) {
        for (final prod in productos) {
          data.add({
            'idprecio': idPrecio++,
            'idproducto': prod.id,
            'nombreproducto': prod.nombre,
            'idcategoriacliente': cat.id,
            'categoriacliente': cat.nombre,
            'valor': prod.precio,
            'mensaje': null,
          });
        }
      }
      return handler.resolve(
        Response(requestOptions: options, statusCode: 200, data: data),
      );
    }

    if (path.contains('/tbasicas/verpromocioneshoy')) {
      return handler.resolve(
        Response(requestOptions: options, statusCode: 200, data: []),
      );
    }

    if (path.contains('/tbasicas/verformaspago')) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: [
            {'idformapago': 1, 'nombreformapago': 'Efectivo', 'mensaje': null},
            {'idformapago': 2, 'nombreformapago': 'Nequi', 'mensaje': null},
            {'idformapago': 3, 'nombreformapago': 'Bancolombia', 'mensaje': null},
            {'idformapago': 4, 'nombreformapago': 'Daviplata', 'mensaje': null},
            {'idformapago': 5, 'nombreformapago': 'Crédito', 'mensaje': null},
          ],
        ),
      );
    }

    if (path.contains('/tbasicas/vervendedor')) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'idvendedor': demoVendedorId,
            'nombre': 'Pepito Perez (Demo)',
            'consecutivoremision': 'PPP30002',
            'idusuario': 999,
            'nombreusuario': demoUsername,
            'fechaultimaventa': todayStr,
            'mensaje': null,
          },
        ),
      );
    }

    if (path.contains('/tbasicas/cargaresumendiavendedor')) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: {'mensaje': 'Cargue resumen del vendedor OK'},
        ),
      );
    }

    handler.next(options);
  }
}

