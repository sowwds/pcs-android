import 'package:flutter/material.dart';
import 'package:madshop_ui_Efremov/models/product.dart';
import 'package:madshop_ui_Efremov/theme/colors.dart';
import 'package:madshop_ui_Efremov/theme/text_styles.dart';

class ProductScreen extends StatefulWidget {
  final Product product;

  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.product.name,
          style: const TextStyle(
            fontFamily: 'NunitoSans',
            fontWeight: FontWeight.normal,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(widget.product.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: const TextStyle(
                              fontFamily: 'NunitoSans',
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${widget.product.price.toStringAsFixed(2)} ₽',
                            style: const TextStyle(
                              fontFamily: 'Raleway',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                widget.product.isInCart = !widget.product.isInCart;
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryButton,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                              ),
                            ),
                            child: Text(
                              widget.product.isInCart ? 'Remove from Cart' : 'Add to Cart',
                              style: AppTextStyles.button,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
