enum MotivoNoVenta {
  stockInsuficiente,
  carritoVacio,
  pagoVacio,
  pagosIncompletos,
  errorDesconocido,
}

extension MotivoNoVentaExtension on MotivoNoVenta {
  String get titulo {
    switch (this) {
      case MotivoNoVenta.stockInsuficiente:
        return 'Stock insuficiente';

      case MotivoNoVenta.carritoVacio:
        return 'Carrito vacío';
      
      case MotivoNoVenta.pagoVacio:
        return 'No registra pagos';

      case MotivoNoVenta.pagosIncompletos:
        return 'Pago incompleto';

      case MotivoNoVenta.errorDesconocido:
        return 'Error inesperado';
    }
  }

  String get detalle {
    switch (this) {
      case MotivoNoVenta.stockInsuficiente:
        return 'No hay existencias suficientes para completar la venta o la promoción.';

      case MotivoNoVenta.carritoVacio:
        return 'Debe agregar al menos un producto antes de finalizar la venta.';
      
      case MotivoNoVenta.pagoVacio:
        return 'Debe agregar al menos un pago antes de finalizar la venta.';

      case MotivoNoVenta.pagosIncompletos:
        return 'El valor registrado en los pagos no cubre el total de la venta.';

      case MotivoNoVenta.errorDesconocido:
        return 'Ocurrió un error inesperado al procesar la venta.';
    }
  }
}