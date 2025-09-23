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

class _CartScreenState extends State<CartScreen> {
  String? selectedVoucherId;

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final userService = Provider.of<UserService>(context);
    final user = userService.currentUser;

    // Dummy cart items
  final cartItems = cartService.items;
  double total = cartItems.fold(0, (sum, item) => sum + item.totalPrice);

    // Get claimed vouchers
    final claimedIds = user?.claimedVouchers ?? [];
    final availableVouchers = <Voucher>[];
    // You may want to get available vouchers from a central place
    // For demo, just create some dummy vouchers
    availableVouchers.addAll([
      DiscountVoucher(
        id: 'v1',
        title: 'Diskon 10%',
        description: 'Dapatkan diskon 10% untuk pembelian minuman.',
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        minPurchase: 40000,
        discountPercentage: 10,
        maxDiscount: 10000,
      ),
      DiscountVoucher(
        id: 'v2',
        title: 'Diskon 20%',
        description: 'Diskon 20% untuk pembelian roti, minimal pembelian Rp50.000.',
        expiryDate: DateTime.now().add(const Duration(days: 14)),
        minPurchase: 50000,
        discountPercentage: 20,
        maxDiscount: 15000,
      ),
      BuyOneGetOneVoucher(
        id: 'v4',
        title: 'Buy 1 Get 1 Cake',
        description: 'Beli 2 item, dapatkan 1 gratis item cake. Minimal pembelian Rp60.000.',
        expiryDate: DateTime.now().add(const Duration(days: 15)),
        minPurchase: 60000,
      ),
    ]);

    Voucher? selectedVoucher;
    if (selectedVoucherId != null) {
      selectedVoucher = availableVouchers.firstWhere(
        (v) => v.id == selectedVoucherId,
        orElse: () => availableVouchers.first,
      );
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
            const SizedBox(width: 8),
            const Text('Keranjang Belanja'),
          ],
        ),
        backgroundColor: const Color(0xFFF5E9DA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Daftar Barang:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
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
                        child: Image.asset(
                          item.imageUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Text('Rp${item.price.toInt()} x ${cartItem.quantity} = Rp${cartItem.totalPrice.toInt()}', style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pilih Voucher:', style: TextStyle(fontWeight: FontWeight.bold)),
                    DropdownButton<String>(
                      value: selectedVoucherId,
                      hint: const Text('Pilih voucher'),
                      items: availableVouchers
                          .where((v) => claimedIds.contains(v.id))
                          .map((voucher) => DropdownMenuItem(
                                value: voucher.id,
                                child: Text(voucher.title),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedVoucherId = value;
                        });
                      },
                    ),
                    if (selectedVoucher != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(selectedVoucher.description),
                      ),
                    const Divider(height: 28, thickness: 1),
                    Text('Total: Rp${total.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (discount > 0)
                      Text('Diskon: -Rp${discount.toInt()}', style: const TextStyle(color: Colors.green)),
                    Text('Total Bayar: Rp${(total - discount).toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Proses checkout
                    final order = Order(
                      items: List.from(cartItems),
                      total: total - discount,
                      date: DateTime.now(),
                      voucherId: selectedVoucherId,
                    );
                    userService.addOrder(order);
                    cartService.clearCart();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesanan berhasil!')));
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.pushReplacementNamed(context, '/menu');
                    });
                  },
                  child: const Text('Checkout'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}