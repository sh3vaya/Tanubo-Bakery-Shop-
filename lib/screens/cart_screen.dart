import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';
import '../models/cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final cartItems = cartService.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
        backgroundColor: const Color(0xFF5D4037),
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                cartService.clearCart();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Keranjang dikosongkan')),
                );
              },
            ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Keranjang kosong',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartItems[index];
                      return _buildCartItem(cartItem, context);
                    },
                  ),
                ),
                _buildTotalSection(context, cartService),
              ],
            ),
    );
  }

  Widget _buildCartItem(CartItem cartItem, BuildContext context) {
    final cartService = Provider.of<CartService>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                cartItem.item.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: Icon(Icons.fastfood, color: Colors.grey[400]),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4037),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp${cartItem.item.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Quantity controls
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 20),
                  onPressed: () {
                    cartService.updateQuantity(cartItem.item.id, cartItem.quantity - 1);
                  },
                ),
                Text(
                  '${cartItem.quantity}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () {
                    cartService.updateQuantity(cartItem.item.id, cartItem.quantity + 1);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSection(BuildContext context, CartService cartService) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Items:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '${cartService.totalItems}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Harga:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Rp${cartService.totalPrice.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Logic untuk checkout
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur checkout akan segera hadir!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D4037),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Checkout Sekarang',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}