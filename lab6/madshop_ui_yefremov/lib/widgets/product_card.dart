import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:madshop_ui_Efremov/models/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 150,
        height: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: 150,
                  height: 150,
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
                  top: 5,
                  left: 5,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      widget.product.isFavorite
                          ? 'assets/images/in-favourites-selected.svg'
                          : 'assets/images/in-favourites.svg',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.product.isFavorite = !widget.product.isFavorite;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 5,
                  left: 5,
                  child: IconButton(
                    icon: SvgPicture.asset(
                      widget.product.isInCart
                          ? 'assets/images/in-cart-selected.svg'
                          : 'assets/images/in-cart.svg',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.product.isInCart = !widget.product.isInCart;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5), // Small gap after image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontFamily: 'NunitoSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2, // Limit to 2 lines
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                '${widget.product.price} ₽',
                style: const TextStyle(
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
