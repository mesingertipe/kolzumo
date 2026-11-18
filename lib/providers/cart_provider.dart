import 'package:flutter/material.dart';
import 'package:kolzumo_app/infrastructure/models/promocion_model.dart';

import '../infrastructure/models/cliente_model.dart';
import 'inventario_provider.dart';
import 'precio_provider.dart';

class CartProvider extends ChangeNotifier {
  // * Variables
  final Map<int, int> _items = {};
  final Map<int, int> _temquantity = {};
  Map<int, int> get items => _items;

  // * Controllers
  final Map<int, TextEditingController> _controllers = {};

  TextEditingController controllerOf(int idProducto) {
    return _controllers.putIfAbsent(
      idProducto,
      () => TextEditingController(text: quantityOf(idProducto).toString()),
    );
  }

  int quantityOf(int idProducto) {
    return _temquantity[idProducto] ?? 0;
  }

  // * Carrito methods
  void addItem(int idProducto) {
    if (_items.containsKey(idProducto)) return;

    final qty = _temquantity[idProducto] ?? 0;

    // no agregar si no hay cantidad
    if (qty <= 0) return;

    // si ya existe, sumar
    if (_items.containsKey(idProducto)) {
      _items[idProducto] = _items[idProducto]! + qty;
    } else {
      _items[idProducto] = qty;
    }
    
    notifyListeners();
  }

  bool inCart(int idProducto) {
    return _items.containsKey(idProducto);
  }

  // * Contador methods

  void increment(int idProducto) {
    _temquantity[idProducto] = (_temquantity[idProducto] ?? 0) + 1;
    notifyListeners();
  }

  void decrement(int idProducto) {
    if (!_temquantity.containsKey(idProducto)) return;

    final current = _temquantity[idProducto]!;
    _temquantity[idProducto] = current - 1;
    
    notifyListeners();
  }

  void remove(int idProducto) {
    _temquantity.remove(idProducto);
    if (_items.containsKey(idProducto)) {
      _items.remove(idProducto);
    }
    notifyListeners();
  }

  // * Modifica cantidad por text controller 
  void setQuantity(int idProducto, int nuevaCantidad) {
    if (nuevaCantidad <= 0) {
      _temquantity.remove(idProducto);
    } else {
      _temquantity[idProducto] = nuevaCantidad;
    }

    notifyListeners();
  }

  // * Limpia lista en carrito y contador
  void clear() {
    _items.clear();
    _temquantity.clear();
    notifyListeners();
  }

  // * Calculos venta 

  double calcularTotal(
    List<MapEntry<int, int>> items,
    InventarioProvider inventario,
    PreciosProvider precio,
    Cliente cliente,) {

    double total = 0;

    for (final entry in items) {
      final product = inventario.getById(entry.key);
      final precioItem = precio.getByIds(entry.key, cliente.idcategoriaCliente);

      if (product != null && precioItem != null) {
        
        total += precioItem.valor * entry.value;
      }
    }

    return total;
  }

  double calcularDescuento(
    List<Promocion> promocion, 
    InventarioProvider inventario,
    PreciosProvider precio,
    Cliente cliente,
    List<MapEntry<int,int>> itemsCart

    ){
    
    double descuento = 0;

    for (final entry in promocion){
      final precioItem = precio.getByIds(entry.idproducto, cliente.idcategoriaCliente);
      final cantidadItem = itemsCart
        .firstWhere((item) => item.key == entry.idproducto)
        .value;

      descuento += (precioItem!.valor * cantidadItem) * (entry.porcentajesobreventa!/100);
    }

    return descuento;
  }

  double calcularIVA(
    List<MapEntry<int,int>> itemsCarrito, 
    InventarioProvider inventario,
    PreciosProvider precio,
    Cliente cliente
    ){

    double totalIVA = 0;

    for (final entry in itemsCarrito) {
      final product = inventario.getById(entry.key);
      final precioItem = precio.getByIds(entry.key, cliente.idcategoriaCliente);

      if (product != null && precioItem != null) {
        
        final procentajeIVA = (precioItem.valor * entry.value) * (product.porcentajeiva/100);

        totalIVA += procentajeIVA;
      }
    }


    return totalIVA;
    
  }

}