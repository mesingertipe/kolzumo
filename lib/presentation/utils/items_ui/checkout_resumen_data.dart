import 'package:kolzumo_app/infrastructure/models/cliente_model.dart';
import 'package:kolzumo_app/infrastructure/models/promocion_model.dart';
import 'package:kolzumo_app/providers/cart_provider.dart';
import 'package:kolzumo_app/providers/inventario_provider.dart';
import 'package:kolzumo_app/providers/precio_provider.dart';


typedef CheckoutResumenData = ({
  List<MapEntry<int, int>> items,
  double total,
  List<Promocion> promocionesItems,
  bool aplicaPromocion,
  bool tieneDescuento,
  bool discriminaIVA,
  double valorIVA,
  double descuento,
});

CheckoutResumenData calcularResumenCheckout({
  required CartProvider cart,
  required InventarioProvider inventario,
  required PreciosProvider precio,
  required Cliente customerSel,
}) {
  final items = cart.items.entries.toList();

  final total = cart.calcularTotal(items, inventario, precio, customerSel);

  // Promociones que aplican para el cliente seleccionado.
  final promocionesItems = items
      .map((item) => inventario.getById(item.key)?.promocion)
      .whereType<Promocion>()
      .where((prom) {
        if (!prom.aplicaPara(customerSel)) {
          return false;
        }

        if (prom.promocionde == 'Descuento') {
          return true;
        }

        final cantidad = cart.items[prom.idproducto] ?? 0;
        return cantidad >= prom.cantidadventa;
      })
      .toList();

  // Promoción por encime o cantidad (no descuento).
  final aplicaPromocion = promocionesItems.any((p) {
    if (p.promocionde == 'Descuento') return false;

    final cantidad = cart.items[p.idproducto] ?? 0;

    return p.aplicaPara(customerSel) && cantidad >= p.cantidadventa;
  });

  final tieneDescuento = promocionesItems.any(
    (prom) => prom.promocionde == 'Descuento',
  );

  final discriminaIVA = customerSel.ivadiscrimina == 1;

  double valorIVA = 0;
  if (discriminaIVA) {
    valorIVA = cart.calcularIVA(items, inventario, precio, customerSel);
  }

  final promocionesDescuento = promocionesItems
      .where((p) => p.promocionde == 'Descuento')
      .toList();

  final descuento = cart.calcularDescuento(
    promocionesDescuento,
    inventario,
    precio,
    customerSel,
    items,
  );

  return (
    items: items,
    total: total,
    promocionesItems: promocionesItems,
    aplicaPromocion: aplicaPromocion,
    tieneDescuento: tieneDescuento,
    discriminaIVA: discriminaIVA,
    valorIVA: valorIVA,
    descuento: descuento,
  );
}