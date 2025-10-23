import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:madshop_ui_Efremov/models/product.dart';
import 'package:madshop_ui_Efremov/theme/colors.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartProducts = products.where((product) => product.isInCart).toList();
    double total = cartProducts.fold(0, (sum, product) => sum + (product.price * product.cartQuantity));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text(
              'Cart',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5), // Small gap between "Cart" and count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: const BoxDecoration(
                color: Color(0xFFE5EBFC),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Text(
                cartProducts.length.toString(),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: cartProducts.length,
        itemBuilder: (context, index) {
          final product = cartProducts[index];
          return CartItem(product: product, onUpdate: () {
            setState(() {});
          });
        },
      ),
      bottomNavigationBar: Container(
        color: AppColors.fieldBackground,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: ${total.toStringAsFixed(2)} ₽',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButton,
                minimumSize: const Size(128, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              child: const Text(
                'Checkout',
                style: TextStyle(
                  fontFamily: 'NunitoSans',
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItem extends StatefulWidget {
  final Product product;
  final VoidCallback onUpdate;

  const CartItem({super.key, required this.product, required this.onUpdate});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    widget.product.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 3,
                left: 3,
                child: IconButton(
                  icon: SvgPicture.asset('assets/images/trash-icon.svg'),
                  onPressed: () {
                    setState(() {
                      widget.product.isInCart = false;
                    });
                    widget.onUpdate();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      '${widget.product.price} ₽',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        IconButton(
                          icon: SvgPicture.asset('assets/images/Less.svg'),
                          onPressed: () {
                            if (widget.product.cartQuantity > 1) {
                              setState(() {
                                widget.product.cartQuantity--;
                              });
                              widget.onUpdate();
                            }
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: const BoxDecoration(
                            color: Color(0xFFD4D9EB),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Text(
                            widget.product.cartQuantity.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        IconButton(
                          icon: SvgPicture.asset('assets/images/More.svg'),
                          onPressed: () {
                            setState(() {
                              widget.product.cartQuantity++;
                            });
                            widget.onUpdate();
                          },
                        ),
                      ],
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
}
