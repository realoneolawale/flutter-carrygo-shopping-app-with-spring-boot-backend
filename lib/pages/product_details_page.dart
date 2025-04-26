import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/dtos/cart_response_dto.dart';
import 'package:shopping_app/dtos/product_response_dto.dart';
import 'package:shopping_app/provider/cart_provider.dart';
import 'package:shopping_app/services/networking.dart';
import 'package:shopping_app/services/sharedpreferences.dart';

class ProductDetailsPage extends StatefulWidget {
  // require product object in page constructor
  final ProductResponseDto product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int selectedSize = 0, selectedSizeIndex = 0;
  static const String imageBaseUrl = 'http://192.168.0.175:40160/';

  void onTap() async {
    int? userId = await SharedPreferenceHelper().getId();
    if (userId < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login to add items to cart.')));
    } else {
      // for variable products
      if (widget.product.sizes.isNotEmpty) {
        if (selectedSize != 0) {
          CartResponseDto cartResponseDto = CartResponseDto(
              price: widget.product.price,
              productId: widget.product.id,
              qty: 1,
              size: widget.product.sizes[selectedSizeIndex].size,
              totalAmount: widget.product.price,
              imageUrl: widget.product.imageUrl,
              productName: widget.product.name);
          // add the product to the database
          await NetworkHelper().addUserCartItem(userId, cartResponseDto,
              int.parse('${widget.product.sizes[selectedSizeIndex].id}'));
          // add the item to provider
          context.read<CartProvider>().addProduct(cartResponseDto);
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product added to cart.')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a size!')));
        }
      } else {
        // for non variable product
        CartResponseDto cartResponseDto = CartResponseDto(
            price: widget.product.price,
            productId: widget.product.id,
            qty: 1,
            size: null,
            totalAmount: widget.product.price,
            imageUrl: widget.product.imageUrl,
            productName: widget.product.name);
        // add the product to the database
        await NetworkHelper().addUserCartItem(userId, cartResponseDto, null);
        // add the item to provider
        context.read<CartProvider>().addProduct(cartResponseDto);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added to cart.')));
      }
    }
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
              child: ClipRect(
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  '$imageBaseUrl${widget.product.imageUrl}',
                  height: 250,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (widget.product.sizes.isNotEmpty)
              SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (widget.product.sizes).length,
                    itemBuilder: (context, index) {
                      final size = (widget.product.sizes)[index];
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSize = size.id;
                              selectedSizeIndex = index;
                            });
                          },
                          child: Chip(
                            label: Text(size.size.toString()),
                            backgroundColor: selectedSize == size.id
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                        ),
                      );
                    }),
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
