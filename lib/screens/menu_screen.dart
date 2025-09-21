import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_service.dart';
import '../models/item.dart';
import 'detail_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Widget _buildMenuItemCard(Item item, BuildContext context) {
    final cartService = Provider.of<CartService>(context, listen: false);
    
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              item.imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 140,
                  color: Colors.grey[100],
                  child: Icon(
                    Icons.fastfood,
                    size: 40,
                    color: Colors.grey[400],
                  ),
                );
              },
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge untuk popular/recommended
                if (item is Cake && item.isPopular)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _buildBadge('POPULAR', Colors.red),
                  )
                else if (item is Drink && item.isRecommended)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _buildBadge('RECOMMENDED', Colors.blue),
                  ),

                // Nama item
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5D4037),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),

                // Deskripsi
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Harga dan Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Harga
                    Expanded(
                      child: Text(
                        'Rp${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5D4037),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Button
                    GestureDetector(
                      onTap: () {
                        cartService.addToCart(item);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.name} ditambahkan ke keranjang'),
                            backgroundColor: const Color(0xFF5D4037),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5D4037),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final breads = dummyItems.where((item) => item is Bread).toList();
    final cakes = dummyItems.where((item) => item is Cake).toList();
    final drinks = dummyItems.where((item) => item is Drink).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Tanubo'),
        backgroundColor: const Color(0xFF5D4037),
        actions: [
          //ICON CART
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              if (cartService.totalItems > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '${cartService.totalItems}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Roti & Pastry
            if (breads.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 12),
                child: Text(
                  '🍞 Roti & Pastry',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ),
              SizedBox(
                height: 290,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: breads.length,
                  itemBuilder: (context, index) {
                    final bread = breads[index];
                    return _buildMenuItemCard(bread, context);
                  },
                ),
              ),
              const SizedBox(height: 28),
            ],

            // Section: Cake
            if (cakes.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 12),
                child: Text(
                  '🎂 Kue & Dessert',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ),
              SizedBox(
                height: 290,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cakes.length,
                  itemBuilder: (context, index) {
                    final cake = cakes[index];
                    return _buildMenuItemCard(cake, context);
                  },
                ),
              ),
              const SizedBox(height: 28),
            ],

            // Section: Minuman
            if (drinks.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 12),
                child: Text(
                  '🥤 Minuman',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ),
              SizedBox(
                height: 290,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: drinks.length,
                  itemBuilder: (context, index) {
                    final drink = drinks[index];
                    return _buildMenuItemCard(drink, context);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}