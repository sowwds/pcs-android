import 'package:flutter/material.dart';
import 'package:madshop_ui_Efremov/models/product.dart';
import 'package:madshop_ui_Efremov/screens/product_screen.dart';
import 'package:madshop_ui_Efremov/widgets/product_card.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    final favoriteProducts = products.where((product) => product.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
        title: const Text(
          'Favourites',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 0,
            childAspectRatio: 0.70,
          ),
          itemCount: favoriteProducts.length,
          itemBuilder: (context, index) {
            return ProductCard(
              product: favoriteProducts[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductScreen(product: favoriteProducts[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
