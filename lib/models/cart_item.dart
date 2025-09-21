import '../models/item.dart';

class CartItem {
  final Item item;
  int quantity;

  CartItem({
    required this.item,
    this.quantity = 1,
  });

  double get totalPrice => item.price * quantity;

  void incrementQuantity() {
    quantity++;
  }
  
  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }
}