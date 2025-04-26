import 'package:flutter/material.dart';
import 'package:shopping_app/dtos/cart_response_dto.dart';
import 'package:shopping_app/services/networking.dart';
import 'package:shopping_app/services/sharedpreferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late int userId = 0;
  late String accessToken = '';
  static const String imageBaseUrl = 'http://192.168.0.175:40160/';

  void getUserId() async {
    userId = await SharedPreferenceHelper().getId();
  }

  void getAccessToken() async {
    accessToken = (await SharedPreferenceHelper().getAccessTokenId())!;
  }

  @override
  Widget build(BuildContext context) {
    getUserId();
    getAccessToken();
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<List<CartResponseDto>>(
            future: NetworkHelper().getUserCartItems(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                      ),
                      Text(
                        "No items in cart",
                        style: Theme.of(context).textTheme.titleSmall,
                      )
                    ],
                  ),
                );
              }

              final carts = snapshot.data;
              final total = carts!
                  .fold<double>(0.0, (sum, cart) => sum + cart.totalAmount);

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: carts.length,
                      itemBuilder: (context, index) {
                        final cartItem = carts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                '$imageBaseUrl${cartItem.imageUrl}'), // NetworkImage
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      content: Text(
                                          'Are you sure you want to remove this product from your cart?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            //print('USER ID: $userId, ACCESS TOKEN: $accessToken');
                                            await NetworkHelper()
                                                .deleteUserCartItem(
                                                    cartItem.productId,
                                                    userId,
                                                    accessToken);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        'Item deleted from cart')));
                                            Navigator.of(context).pop();
                                            setState(() {});
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
                            cartItem.size!.isEmpty
                                ? '${cartItem.productName.toString()} | \$${cartItem.price.toStringAsFixed(2).toString()}'
                                : '${cartItem.productName.toString()} | ${cartItem.size} | \$${cartItem.price.toStringAsFixed(2).toString()}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          subtitle: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await NetworkHelper().increaseUserCartItem(
                                      cartItem.productId,
                                      userId,
                                      accessToken,
                                      "increase");
                                  setState(() {});
                                },
                                child: Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${cartItem.qty}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (cartItem.qty == 1) {
                                    await NetworkHelper().deleteUserCartItem(
                                        cartItem.productId,
                                        userId,
                                        accessToken);
                                    setState(() {});
                                  } else {
                                    await NetworkHelper().decreaseUserCartItem(
                                        cartItem.productId,
                                        userId,
                                        accessToken,
                                        "decrease");
                                    setState(() {});
                                  }
                                },
                                child: Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 60,
                              ),
                              Text(
                                '\$${cartItem.totalAmount.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: \$${total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Coming soon!!!')));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            //minimumSize: const Size(double.infinity, 50),
                            fixedSize: const Size(200, 50),
                          ),
                          child: const Text(
                            'Checkout',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
