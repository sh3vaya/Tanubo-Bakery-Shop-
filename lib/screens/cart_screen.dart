import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';
import '../services/user_service.dart';
import '../models/voucher.dart';
import '../models/user.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with SingleTickerProviderStateMixin {
  String? selectedVoucherId;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showVoucherModal(List<Voucher> vouchers, double total) {
    final eligibleVouchers = vouchers
        .where((v) => v.isValid(total))
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF5E9DA),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        if (eligibleVouchers.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text(
                'Belum ada voucher yang bisa digunakan 😔',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          );
        }

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, scrollController) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "🎁 Pilih Voucher Aktif",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: eligibleVouchers.length,
                    itemBuilder: (context, index) {
                      final voucher = eligibleVouchers[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(voucher.title,
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(voucher.description),
                          trailing: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedVoucherId = voucher.id;
                                _controller.forward(from: 0);
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBCA177),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Gunakan"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final userService = Provider.of<UserService>(context);
    final cartItems = cartService.items;

    double total = cartItems.fold(0, (sum, item) => sum + item.totalPrice);

    final availableVouchers = <Voucher>[
      DiscountVoucher(
        id: 'v2',
        title: 'Diskon 20%',
        description: 'Diskon 20% (max Rp15000). Minimal pembelian Rp50.000.',
        expiryDate: DateTime.now().add(const Duration(days: 14)),
        minPurchase: 50000,
        discountPercentage: 20,
        maxDiscount: 15000,
      ),
      DiscountVoucher(
        id: 'v1',
        title: 'Diskon 10%',
        description: 'Diskon 10% (max Rp10000). Minimal pembelian Rp40.000.',
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        minPurchase: 40000,
        discountPercentage: 10,
        maxDiscount: 10000,
      ),
      BuyOneGetOneVoucher(
        id: 'v4',
        title: 'Buy 1 Get 1 Cake',
        description: 'Beli 2 item, dapatkan 1 gratis item cake. Minimal pembelian Rp60.000.',
        expiryDate: DateTime.now().add(const Duration(days: 15)),
        minPurchase: 60000,
      ),
    ];

    Voucher? selectedVoucher;
    if (selectedVoucherId != null) {
      try {
        selectedVoucher =
            availableVouchers.firstWhere((v) => v.id == selectedVoucherId);
      } catch (e) {
        selectedVoucher = null;
      }
    }

    double discount = 0;
    if (selectedVoucher != null && selectedVoucher.isValid(total)) {
      discount = selectedVoucher.applyDiscount(total);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.shopping_cart, color: Color(0xFFBCA177), size: 28),
            SizedBox(width: 8),
            Text('Keranjang Belanja'),
          ],
        ),
        backgroundColor: const Color(0xFFF5E9DA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartItems[index];
                  final item = cartItem.item;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(item.imageUrl,
                            width: 60, height: 60, fit: BoxFit.cover),
                      ),
                      title: Text(item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.description,
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          Row(
                            children: [
                              Text(
                                'Rp${item.price.toInt()} x ${cartItem.quantity} = Rp${cartItem.totalPrice.toInt()}',
                              ),
                              const SizedBox(width: 16),
                              // Tombol tambah item
                              IconButton(
                                icon: const Icon(Icons.add_circle, color: Color(0xFFBCA177)),
                                onPressed: () {
                                  cartService.addToCart(item);
                                },
                              ),
                              // Tombol kurang item
                              IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
                                onPressed: () {
                                  cartService.removeFromCart(item.id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            FadeTransition(
              opacity: _fadeAnimation,
              child: selectedVoucherId != null
                  ? Row(
                children: const [
                  Icon(Icons.local_offer, color: Colors.green),
                  SizedBox(width: 6),
                  Text(
                    'Voucher aktif 🎉',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: Rp${total.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (discount > 0)
                      Text('Diskon: -Rp${discount.toInt()}',
                          style: const TextStyle(color: Colors.green)),
                    Text('Total Bayar: Rp${(total - discount).toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _showVoucherModal(availableVouchers, total),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBCA177),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        icon: const Icon(Icons.card_giftcard),
                        label: const Text('Pilih Voucher'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final order = Order(
                    items: List.from(cartItems),
                    total: total - discount,
                    date: DateTime.now(),
                    voucherId: selectedVoucher?.id,
                  );
                  userService.addOrder(order);
                  cartService.clearCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pesanan berhasil!')));
                      (const Duration(milliseconds: 500), () {
                    Navigator.pushReplacementNamed(context, '/menu');
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBCA177),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
