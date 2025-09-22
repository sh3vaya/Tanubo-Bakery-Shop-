import 'package:flutter/foundation.dart'; 
import '../models/cart_item.dart';
import '../models/item.dart';

class CartService with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  
  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);
  
  double get totalPrice => _items.fold(0.0, (sum, item) => sum + (item.item.price * item.quantity));

  void addToCart(Item item) {
    final existingIndex = _items.indexWhere((cartItem) => cartItem.item.id == item.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(item: item));
    }
    notifyListeners();
  }

  void removeFromCart(String itemId) {
    _items.removeWhere((item) => item.item.id == itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int newQuantity) {
    final index = _items.indexWhere((item) => item.item.id == itemId);
    if (index >= 0) {
      if (newQuantity <= 0) {
        removeFromCart(itemId);
      } else {
        _items[index].quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}