import 'package:flutter/material.dart';
import '../models/item.dart';
import 'detail_screen.dart';

//variable dummy item
final List<Item> dummyItems = [
  Bread(
    id: '1',
    name: 'Almond Croissant',
    description: 'Croissant renyah berlapis butter premium, ditaburi irisan almond panggang dan gula halus untuk rasa gurih dan manis seimbang.',
    price: 28000,
    imageUrl: 'assets/images/menu/almond_croissant.png',
  ),
  Bread(
    id: '2',
    name: 'Cheese Danish',
    description: 'Pastry lembut dengan isian keju krim yang creamy dan topping gula glaze tipis, sempurna untuk teman kopi.',
    price: 26000,
    imageUrl: 'assets/images/menu/cheese_danish.png',
  ),
  Bread(
    id: '3',
    name: 'Strawberry Danish',
    description: 'CDanish pastry berlapis renyah dengan selai strawberry segar dan topping buah strawberry untuk sentuhan segar dan manis.',
    price: 27000,
    imageUrl: 'assets/images/menu/strawberry_danish.png',
  ),
  Bread(
    id: '4',
    name: 'Cromboloni',
    description: 'Pastry viral yang memadukan kelembutan bomboloni dan kerenyahan croissant, dengan filling cokelat lumer di dalam',
    price: 32000,
    imageUrl: 'assets/images/menu/cromboloni.png',
  ),
  Bread(
    id: '5',
    name: 'Garlic Bread',
    description: 'Roti bulat lembut dengan isi cream cheese, dipanggang dengan saus garlic butter khas Korea, rasa gurih dan creamy yang bikin ketagihan.',
    price: 30000,
    imageUrl: 'assets/images/menu/garlic_bread.png',
  ),
  Cake(
    id: '1',
    name: 'Chessecake',
    description: 'Cheesecake klasik dengan tekstur lembut dan rasa creamy, disajikan dengan base biskuit yang gurih.',
    price: 35000,
    imageUrl: 'assets/images/menu/cheesecake.png',
    isPopular: true,
  ),
  Cake(
    id: '2',
    name: 'Chocolate Lava Cake',
    description: 'Kue cokelat lembut dengan lelehan cokelat hangat di tengah, cocok untuk pencinta cokelat sejati.',
    price: 38000,
    imageUrl: 'assets/images/menu/chocolate_lava_cake.png',
    isPopular: false,
  ),
  Cake(
    id: '3',
    name: 'Red Velvet Cheesecake',
    description: 'Perpaduan kue red velvet yang moist dengan lapisan cheesecake yang creamy.',
    price: 35000,
    imageUrl: 'assets/images/menu/red_velvet_cheesecake.png',
    isPopular: false,
  ),
  Cake(
    id: '4',
    name: 'Tiramisu',
    description: 'Dessert klasik Italia dengan lapisan sponge cake kopi dan krim mascarpone yang lembut, taburan cocoa di atasnya.',
    price: 40000,
    imageUrl: 'assets/images/menu/chocolate_lava_cake.png',
    isPopular: false,
  ),
  Drink(
    id: '1',
    name: 'Biscoff Affogato',
    description: 'Affogato premium dengan espresso hangat, es krim vanilla, dan taburan biskuit Lotus Biscoff yang manis gurih.',
    price: 30000,
    imageUrl: 'assets/images/menu/biscoff_affogato.png',
    isRecommended: true,
  ),
  Drink(
    id: '2',
    name: 'Hazelnut Latte',
    description: 'Espresso, susu segar, dan sirup hazelnut yang menghasilkan rasa kacang lembut dan wangi.',
    price: 32000,
    imageUrl: 'assets/images/menu/hazelnut_latte.png',
    isRecommended: false,
  ),
  Drink(
    id: '3',
    name: 'Caramel Macchiato',
    description: 'Perpaduan espresso dan susu dengan sirup vanilla, dilengkapi drizzle caramel yang kaya rasa.',
    price: 34000,
    imageUrl: 'assets/images/menu/caramel_macchiato.png',
    isRecommended: false,
  ),
  Drink(
    id: '4',
    name: 'Koguren',
    description: 'Es kopi susu klasik dengan manis alami dari gula aren premium.',
    price: 27000,
    imageUrl: 'assets/images/menu/kopguren.png',
    isRecommended: false,
  ),
  Drink(
    id: '5',
    name: 'Matcha Latte',
    description: 'Minuman creamy dengan matcha premium, rasa earthy yang lembut dan segar.',
    price: 32000,
    imageUrl: 'assets/images/menu/matcha_latte.png',
    isRecommended: false,
  ),
  Drink(
    id: '6',
    name: 'Red Velvet Latte',
    description: 'Latte manis dengan rasa khas red velvet, creamy dan cantik dengan warna merah menggoda.',
    price: 33000,
    imageUrl: 'assets/images/menu/red_velvet_latte.png',
    isRecommended: false,
  ),
  Drink(
    id: '7',
    name: 'Taro Latte',
    description: 'Minuman creamy dengan rasa talas manis dan wangi yang unik.',
    price: 33000,
    imageUrl: 'assets/images/menu/taro_latte.png',
    isRecommended: false,
  ),
  Drink(
    id: '8',
    name: 'Tarcha Latte',
    description: 'Kombinasi matcha premium dan taro creamy, rasa unik yang harmonis dan memanjakan lidah.',
    price: 36000,
    imageUrl: 'assets/images/menu/tarcha_latte.png',
    isRecommended: false,
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