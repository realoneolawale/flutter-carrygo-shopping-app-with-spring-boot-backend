import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/dtos/cart_response_dto.dart';
import 'package:shopping_app/services/networking.dart';
import 'package:shopping_app/services/sharedpreferences.dart';

import '../provider/cart_provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<CartResponseDto> cart = context.watch<CartProvider>().cart;

  @override
  initState() {
    getUserCartItems();
    super.initState();
  }

  getUserCartItems() async {
    NetworkHelper helper = NetworkHelper();
    int userId = await SharedPreferenceHelper().getId() ?? 0;
    dynamic response = await helper.getUserCartItems(userId);
    // to the the product list page or profile page
    if (response == null) {
      cart = response;
    } else {
      cart = []; // get the cart from API with user id
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(Provider.of<String>(context));
    //final cart = Provider.of<CartProvider>(context).cart;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: cart.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: cart.length,
                itemBuilder: (context, index) {
                  final cartItem = cart[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(cartItem.imageUrl), // NetworkImage
                      radius: 30,
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                            barrierDismissible:
                                false, // user cannot click outside the dialog
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  'Delete Product',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                content: Text(
                                    'Are you sure you want to remove this product from your cart?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      context
                                          .read<CartProvider>()
                                          .removeProduct(cartItem);
                                      // TODO: remove item from the database
                                      // Provider.of<CartProvider>(context)
                                      //     .removeProduct(cartItem);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              );
                            });
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    title: Text(
                      cartItem.productName.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    //subtitle: Text('Size ${cartItem['size']}'),
                  );
                },
              ),
      ),
    );
  }
}
