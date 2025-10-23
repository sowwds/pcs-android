// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:madshop_ui_Efremov/models/product.dart';
import 'package:madshop_ui_Efremov/screens/favourites_screen.dart';
import 'package:madshop_ui_Efremov/screens/cart_screen.dart';
import 'package:madshop_ui_Efremov/screens/product_screen.dart';
import 'package:madshop_ui_Efremov/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    HomeScreenContent(), // Updated to non-const for state
    FavouritesScreen(),
    CartScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 0
                  ? 'assets/images/home-icon-selected.svg'
                  : 'assets/images/home-icon.svg',
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 1
                  ? 'assets/images/favourites-icon-selected.svg'
                  : 'assets/images/favourites-icon.svg',
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _selectedIndex == 2
                  ? 'assets/images/cart-icon-selected.svg'
                  : 'assets/images/cart-icon.svg',
            ),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({super.key});

  @override
  State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Product> _displayedProducts = List.from(products);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _displayedProducts = products
          .where((product) => product.name.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: null, // Explicitly remove leading
        automaticallyImplyLeading: false, // Prevent automatic back button
        title: _isSearching
            ? Container(
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFD2D7E8),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Clothing',
                    hintStyle: const TextStyle(
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.w100,
                      fontSize: 16,
                      color: Color(0xFF033FCE),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _isSearching = false;
                        });
                      },
                    ),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Shop',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    height: 36,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2D7E8),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: TextField(
                      controller: _searchController,
                      textAlignVertical: TextAlignVertical.center,
                      onTap: () {
                        setState(() {
                          _isSearching = true;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Clothing',
                        hintStyle: const TextStyle(
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color(0xFF033FCE),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      ),
                    ),
                  ),
                ],
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
          itemCount: _displayedProducts.length,
          itemBuilder: (context, index) {
            return ProductCard(
              product: _displayedProducts[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductScreen(product: _displayedProducts[index]),
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
