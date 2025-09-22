import '../models/cart_item.dart';



class User {
  String name;
  int purchaseCount;
  int totalPoints;
  List<String> claimedVouchers;
  int dailyLoginCount;
  String email;

  User({
    required this.name,
    required this.purchaseCount,
    required this.totalPoints,
    required this.claimedVouchers,
    required this.dailyLoginCount,
    required this.email,
  });
}

class Order {
  final List<CartItem> items;
  final double total;
  final DateTime date;
  final String? voucherId;

  Order({
    required this.items,
    required this.total,
    required this.date,
    this.voucherId,
  });
}
