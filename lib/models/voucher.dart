// Abstract class untuk inheritance
abstract class Voucher {
  final String id;
  final String title;
  final String description;
  final DateTime expiryDate;
  final double minPurchase;

  Voucher({
    required this.id,
    required this.title,
    required this.description,
    required this.expiryDate,
    required this.minPurchase,
  });

  double applyDiscount(double totalAmount);
  bool isValid(double totalAmount);
}

// Discount voucher - inheritance
class DiscountVoucher extends Voucher {
  final double discountPercentage;
  final double maxDiscount;

  DiscountVoucher({
    required String id,
    required String title,
    required String description,
    required DateTime expiryDate,
    required double minPurchase,
    required this.discountPercentage,
    required this.maxDiscount,
  }) : super(
          id: id,
          title: title,
          description: description,
          expiryDate: expiryDate,
          minPurchase: minPurchase,
        );

  @override
  double applyDiscount(double totalAmount) {
    if (!isValid(totalAmount)) return 0;
    
    double discount = totalAmount * (discountPercentage / 100);
    return discount > maxDiscount ? maxDiscount : discount;
  }

  @override
  bool isValid(double totalAmount) {
    return totalAmount >= minPurchase && DateTime.now().isBefore(expiryDate);
  }
}

// Buy X Get Y voucher - inheritance
class BuyXGetYVoucher extends Voucher {
  final int buyQuantity;
  final int getQuantity;

  BuyXGetYVoucher({
    required String id,
    required String title,
    required String description,
    required DateTime expiryDate,
    required double minPurchase,
    required this.buyQuantity,
    required this.getQuantity,
  }) : super(
          id: id,
          title: title,
          description: description,
          expiryDate: expiryDate,
          minPurchase: minPurchase,
        );

  @override
  double applyDiscount(double totalAmount) {
    if (!isValid(totalAmount)) return 0;
    // Logic untuk buy X get Y
    return totalAmount * (getQuantity / (buyQuantity + getQuantity));
  }

  @override
  bool isValid(double totalAmount) {
    return totalAmount >= minPurchase && DateTime.now().isBefore(expiryDate);
  }
}

// Free item voucher - inheritance
class FreeItemVoucher extends Voucher {
  final String freeItemName;
  final double freeItemValue;

  FreeItemVoucher({
    required String id,
    required String title,
    required String description,
    required DateTime expiryDate,
    required double minPurchase,
    required this.freeItemName,
    required this.freeItemValue,
  }) : super(
          id: id,
          title: title,
          description: description,
          expiryDate: expiryDate,
          minPurchase: minPurchase,
        );

  @override
  double applyDiscount(double totalAmount) {
    if (!isValid(totalAmount)) return 0;
    return freeItemValue;
  }

  @override
  bool isValid(double totalAmount) {
    return totalAmount >= minPurchase && DateTime.now().isBefore(expiryDate);
  }
}