// lib/models/product.dart

class Product {
  final String id;
  final String imagePath;
  final String name;
  final int price;
  bool isFavorite;
  bool isInCart;
  int cartQuantity;

  Product({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.price,
    this.isFavorite = false,
    this.isInCart = false,
    this.cartQuantity = 1,
  });
}

final List<Product> products = [
  Product(
    id: '1',
    imagePath: 'assets/images/fliska_swords.png',
    name: 'Флиска SWORDS',
    price: 9800,
  ),
  Product(
    id: '2',
    imagePath: 'assets/images/jamper_masverk.png',
    name: 'Джемпер MASVERK',
    price: 8900,
  ),
  Product(
    id: '3',
    imagePath: 'assets/images/tshirt_warrior_wolf.png',
    name: 'Футболка WARRIOR WOLF',
    price: 4800,
  ),
  Product(
    id: '4',
    imagePath: 'assets/images/backpack_dungeon.png',
    name: 'Рюкзак DUNGEON EXPLORER',
    price: 11000,
  ),
  Product(
    id: '5',
    imagePath: 'assets/images/tshirt_sasha_sulim.png',
    name: 'Футболка SASHA SULIM',
    price: 8500,
  ),
  Product(
    id: '6',
    imagePath: 'assets/images/jamper_ranim.png',
    name: 'Джемпер РАНИМ',
    price: 11500,
  ),
  Product(
    id: '7',
    imagePath: 'assets/images/tshirt_nazgul.png',
    name: 'Футболка NAZGUL',
    price: 4800,
  ),
  // Add more products as needed
];
