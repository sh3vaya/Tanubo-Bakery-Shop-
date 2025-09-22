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
        title: const Text('Keranjang Belanja'),
        backgroundColor: const Color(0xFF5D4037),
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
                  return ListTile(
                    title: Text(cartItem.item.name),
                    subtitle: Text('Rp${cartItem.item.price.toInt()} x ${cartItem.quantity} = Rp${cartItem.totalPrice.toInt()}'),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            Text('Total: Rp${total.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
            if (discount > 0)
              Text('Diskon: -Rp${discount.toInt()}', style: const TextStyle(color: Colors.green)),
            Text('Total Bayar: Rp${(total - discount).toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Proses checkout
                final order = Order(
                  items: List.from(cartItems),
                  total: total - discount,
                  date: DateTime.now(),
                  voucherId: selectedVoucherId,
                );
                userService.addOrder(order);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pesanan berhasil!')));
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}