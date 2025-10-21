import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/user_service.dart';
import '../models/cart_item.dart';

class OrderHistoryScreen extends StatelessWidget {
  OrderHistoryScreen({super.key});

  final NumberFormat _currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context);
    final orders = userService.orders;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pemesanan'),
        backgroundColor: const Color(0xFF5D4037),
      ),
      body: orders.isEmpty
          ? const Center(child: Text('Belum ada riwayat pemesanan'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tanggal: ${order.date.day}/${order.date.month}/${order.date.year}'),
                        Text(_currencyFormatter.format(order.total), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    subtitle: order.voucherId != null ? Text('Voucher: ${order.voucherId}') : null,
                    children: [
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: order.items.map<Widget>((CartItem cartItem) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: SizedBox(
                                width: 48,
                                height: 48,
                                child: Image.asset(
                                  cartItem.item.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                                ),
                              ),
                              title: Text(cartItem.item.name),
                              subtitle: Text('Harga: ${_currencyFormatter.format(cartItem.item.price)}'),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('x${cartItem.quantity}'),
                                  const SizedBox(height: 4),
                                  Text(_currencyFormatter.format(cartItem.totalPrice), style: const TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total pesanan', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(_currencyFormatter.format(order.total), style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}