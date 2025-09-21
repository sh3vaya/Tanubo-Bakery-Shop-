class Item {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  void showInfo() {
    print('Item: $name, Price: $price');
  }
}

// Inheritance: Cake dan Drink turunan dari Item
class Cake extends Item {
  final bool isPopular;

  Cake({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    this.isPopular = false,
  }) : super(
          id: id,
          name: name,
          description: description,
          price: price,
          imageUrl: imageUrl,
        );

  @override
  void showInfo() {
    print('Cake: $name, Popular: $isPopular');
  }
}

class Drink extends Item {
  final bool isRecommended;

  Drink({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    this.isRecommended = false,
  }) : super(
          id: id,
          name: name,
          description: description,
          price: price,
          imageUrl: imageUrl,
        );

  @override
  void showInfo() {
    print('Drink: $name, Recommended: $isRecommended');
  }

//Data dumy untuk item
List<Item> dummyItems = [
  Cake(
    id: '1',
    name: 'Red Velvet Cake',
    description: 'Kue lembut dengan cream cheese frosting yang legit',
    price: 85000,
    imageUrl: 'https://example.com/red_velvet.jpg',
    isPopular: true,
  ),
  Cake(
    id: '2',
    name: 'Chocolate Lava',
    description: 'Kue coklat dengan lelehan coklat di dalamnya',
    price: 75000,
    imageUrl: 'https://example.com/chocolate_lava.jpg',
    isPopular: true,
  ),
  Drink(
    id: '3',
    name: 'Matcha Latte',
    description: 'Minuman matcha dengan susu segar',
    price: 35000,
    imageUrl: 'https://example.com/matcha_latte.jpg',
    isRecommended: true,
  ),
  Drink(
    id: '4',
    name: 'Caramel Macchiato',
    description: 'Kopi dengan caramel dan susu steamed',
    price: 40000,
    imageUrl: 'https://example.com/caramel_macchiato.jpg',
    isRecommended: true,
  ),
  Item(
    id: '5',
    name: 'Croissant Almond',
    description: 'Croissant renyah dengan isian almond cream',
    price: 25000,
    imageUrl: 'https://example.com/almond_croissant.jpg',
  ),
  Item(
    id: '6',
    name: 'Tiramisu',
    description: 'Dessert Italia dengan rasa kopi yang khas',
    price: 45000,
    imageUrl: 'https://example.com/tiramisu.jpg',
  ),
];
}