import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
// import '../models/user.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

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
                  child: ListTile(
                    title: Text('Total: Rp${order.total.toInt()}'),
                    subtitle: Text('Tanggal: ${order.date.day}/${order.date.month}/${order.date.year}'),
                    trailing: order.voucherId != null
                        ? Text('Voucher: ${order.voucherId}')
                        : null,
                  ),
                );
              },
            ),
    );
  }
}