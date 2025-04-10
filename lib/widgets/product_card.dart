import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final double price;
  final String image;
  final Color backgroundColor;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: backgroundColor,
        //color: Color.fromRGBO(216, 240, 253, 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 5),
          Text('\$$price', style: Theme.of(context).textTheme.bodySmall),
          Center(
            child: Image(
              image: AssetImage(image),
              height: 175,
            ),
          ),
          // Image.Asset(image, height: 175),
        ],
      ),
    );
  }
}
