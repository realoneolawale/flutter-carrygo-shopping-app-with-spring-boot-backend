import 'package:flutter/material.dart';
import 'package:shopping_app/dtos/cart_response_dto.dart';
import 'package:shopping_app/dtos/product_response_dto.dart';

class ProductDetailsPage extends StatefulWidget {
  // require product object in page constructor
  final ProductResponseDto product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int selectedSize = 0;
  static const String imageBaseUrl = 'http://192.168.0.175:40160/';

  void onTap() {
    CartResponseDto cartResponseDto = CartResponseDto(
        price: 0,
        productId: 0,
        qty: 0,
        totalAmount: 0,
        imageUrl: '',
        productName: '');
    // if (selectedSize != 0) {
    //   Provider.of<CartProvider>(context, listen: false)
    //       //.addProduct(widget.product);
    //       .addProduct({
    //     'id': widget.product['id'],
    //     'company': widget.product['company'],
    //     'title': widget.product['title'],
    //     'price': widget.product['price'],
    //     'imageUrl': widget.product['imageUrl'],
    //     'size': selectedSize,
    //   });
    //   ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text('Product Added to Cart!')));
    // } else {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(const SnackBar(content: Text('Please select a size!')));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: SafeArea(
        child: Column(
          children: [
            Text(
              widget.product.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Image.network(
                '$imageBaseUrl${widget.product.imageUrl}',
                height: 250,
              ),
            ),
            const Spacer(flex: 2),
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Color.fromRGBO(245, 247, 249, 1),
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "\$${widget.product.price.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  // sized box
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(widget.product.details)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      onPressed: onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        //minimumSize: const Size(double.infinity, 50),
                        fixedSize: const Size(350, 50),
                      ),
                      child: const Text(
                        'Add To Cart',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
