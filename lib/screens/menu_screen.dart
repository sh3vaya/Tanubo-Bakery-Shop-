import 'package:flutter/material.dart';
import '../models/item.dart';
import 'detail_screen.dart';

//variable dummy item
final List<Item> dummyItems = [
  Cake(
    id: 'cake1',
    name: 'Chocolate Cake',
    description: 'Delicious chocolate layered cake',
    price: 50000,
    imageUrl: 'https://example.com/images/chocolate_cake.jpg',
    isPopular: true,
  ),
  Cake(
    id: 'cake2',
    name: 'Vanilla Cake',
    description: 'Classic vanilla sponge cake',
    price: 45000,
    imageUrl: 'https://example.com/images/vanilla_cake.jpg',
    isPopular: false,
  ),
  Drink(
    id: 'drink1',
    name: 'Cappuccino',
    description: 'Rich and creamy cappuccino',
    price: 30000,
    imageUrl: 'https://example.com/images/cappuccino.jpg',
    isRecommended: true,
  ),
  Drink(
    id: 'drink2',
    name: 'Green Tea Latte',
    description: 'Smooth and refreshing green tea latte',
    price: 35000,
    imageUrl: 'https://example.com/images/green_tea_latte.jpg',
    isRecommended: false,
  ),
  Item(
    id: 'item1',
    name: 'Croissant',
    description: 'Buttery and flaky croissant',
    price: 20000,
    imageUrl: 'https://example.com/images/croissant.jpg',
  ),
  Item(
    id: 'item2',
    name: 'Bagel',
    description: 'Chewy and delicious bagel',
    price: 15000,
    imageUrl: 'https://example.com/images/bagel.jpg',
  ),
];

//class menuscreen
class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  Widget _buildMenuItemCard(Item item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(item: item),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
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
              child: Image.network(
                item.imageUrl,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 140,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.fastfood,
                      size: 50,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge untuk popular/recommended
                  if (item is Cake && item.isPopular)
                    _buildBadge('POPULAR', Colors.red)
                  else if (item is Drink && item.isRecommended)
                    _buildBadge('RECOMMENDED', Colors.blue),
                  
                  if ((item is Cake && item.isPopular) || (item is Drink && item.isRecommended))
                    const SizedBox(height: 4),

                  // Nama item
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D4037),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Deskripsi
                  Text(
                    item.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Harga dan Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rp${item.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4037),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_shopping_cart,
                          color: Color(0xFF5D4037),
                          size: 20,
                        ),
                        onPressed: () {
                          // Tambahkan ke cart
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.name} ditambahkan ke keranjang'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Kategorikan items
    final popularCakes = dummyItems.whereType<Cake>().where((cake) => cake.isPopular).toList();
    final recommendedDrinks = dummyItems.whereType<Drink>().where((drink) => drink.isRecommended).toList();
    final otherItems = dummyItems.where((item) => item is! Cake && item is! Drink).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Hits Hari Ini'),
        backgroundColor: const Color(0xFF5D4037),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Popular Cakes
            if (popularCakes.isNotEmpty) ...[
              const Text(
                '🎂 Cake Populer',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularCakes.length,
                  itemBuilder: (context, index) {
                    final cake = popularCakes[index];
                    return _buildMenuItemCard(cake, context);
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Section: Recommended Drinks
            if (recommendedDrinks.isNotEmpty) ...[
              const Text(
                '🥤 Minuman Recommended',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedDrinks.length,
                  itemBuilder: (context, index) {
                    final drink = recommendedDrinks[index];
                    return _buildMenuItemCard(drink, context);
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Section: Other Items
            if (otherItems.isNotEmpty) ...[
              const Text(
                '🍞 Menu Lainnya',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.7,
                ),
                itemCount: otherItems.length,
                itemBuilder: (context, index) {
                  final item = otherItems[index];
                  return _buildMenuItemCard(item, context);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}