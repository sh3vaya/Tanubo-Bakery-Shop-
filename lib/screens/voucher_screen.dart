import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../models/voucher.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  List<Voucher> getAvailableVouchers() {
    return [
      DiscountVoucher(
        id: 'v1',
        title: 'Diskon 10%',
        description: 'Dapatkan diskon 10% untuk pembelian minuman.',
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        minPurchase: 40000, // minimal pembelian Rp40.000
        discountPercentage: 10,
        maxDiscount: 10000,
      ),
      DiscountVoucher(
        id: 'v2',
        title: 'Diskon 20%',
        description: 'Diskon 20% untuk pembelian roti, minimal pembelian Rp50.000.',
        expiryDate: DateTime.now().add(const Duration(days: 14)),
        minPurchase: 50000, // minimal pembelian Rp50.000
        discountPercentage: 20,
        maxDiscount: 15000,
      ),
      DiscountVoucher(
        id: 'v3',
        title: 'Gratis Kopi',
        description: 'Beli minimal Rp70.000, dapatkan kopi gratis.',
        expiryDate: DateTime.now().add(const Duration(days: 10)),
        minPurchase: 70000, // minimal pembelian Rp70.000
        discountPercentage: 100,
        maxDiscount: 25000,
      ),
      BuyOneGetOneVoucher(
        id: 'v4',
        title: 'Buy 1 Get 1 Cake',
        description: 'Beli 2 item, dapatkan 1 gratis item cake. Minimal pembelian Rp60.000.',
        expiryDate: DateTime.now().add(const Duration(days: 15)),
        minPurchase: 60000,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voucher Saya', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF5D4037),
      ),
      body: Consumer<UserService>(
        builder: (context, userService, child) {
          final user = userService.currentUser;
          final availableVouchers = getAvailableVouchers();
          final claimedIds = user?.claimedVouchers ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: availableVouchers.length,
            itemBuilder: (context, index) {
              final voucher = availableVouchers[index];
              final isClaimed = claimedIds.contains(voucher.id);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.confirmation_number, color: Color(0xFF5D4037)),
                  title: Text(voucher.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(voucher.description),
                      Text('Minimal pembelian: Rp${voucher.minPurchase.toInt()}'),
                      Text('Kadaluarsa: ${voucher.expiryDate.day}/${voucher.expiryDate.month}/${voucher.expiryDate.year}'),
                    ],
                  ),
                  trailing: isClaimed
                      ? const Text('Sudah diklaim', style: TextStyle(color: Colors.green))
                      : ElevatedButton(
                          onPressed: user == null
                              ? null
                              : () {
                                  user.claimedVouchers.add(voucher.id);
                                  userService.notifyListeners();
                                },
                          child: const Text('Klaim'),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
