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

// Inheritance: Bread, Cake dan Drink turunan dari Item
//class bread
class Bread extends Item {
  final bool isWholeGrain;

  Bread({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    this.isWholeGrain = false,
  }) : super(
          id: id,
          name: name,
          description: description,
          price: price,
          imageUrl: imageUrl,
        );

  @override
  void showInfo() {
    print('Bread: $name, Whole Grain: $isWholeGrain');
  }
}

//class cake
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

//class minuman
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
}

//Data dumy untuk item
List<Item> dummyItems = [
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
    description: 'Danish pastry berlapis renyah dengan selai strawberry segar dan topping buah strawberry untuk sentuhan segar dan manis.',
    price: 27000,
    imageUrl: 'assets/images/menu/strawbery_danish.png',
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
    imageUrl: 'assets/images/menu/tiramisu.png',
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