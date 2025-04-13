import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/dtos/auth_response_dto.dart';
import 'package:shopping_app/provider/cart_provider.dart';
import 'package:shopping_app/provider/navigation_provider.dart';
import 'package:shopping_app/widgets/product_card.dart';

import '../global_variables.dart';
import '../pages/product_details_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});
  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<String> filters = const ['All', 'Addidas', 'Nike', 'Bata', 'Puma'];
  late String selectedFilter;
  late String loggedInUser;
  late AuthResponseDto authResponseUser;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // logged in user icons
    List<Widget> icons = [];
    // track the selected category
    selectedFilter = filters[0];
    // set the currently logged in user
    final navigationProvider = Provider.of<NavigationProvider>(context);
    authResponseUser =
        Provider.of<CartProvider>(context).user; // listen for changes
    // set the logged in user
    if (authResponseUser.firstName.toString().isNotEmpty) {
      loggedInUser = "Hi ${authResponseUser.firstName} ⛄️";
      icons.add(IconButton(
        icon: Icon(Icons.logout),
        onPressed: () {
          //Implement logout functionality - set auth user to null
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'Logout',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Provider.of<CartProvider>(context, listen: false).user =
                            AuthResponseDto(
                                accessToken: '',
                                tokenType: '',
                                id: 0,
                                firstName: '',
                                email: '',
                                username: '');
                        // redirect to the product list tab
                        navigationProvider.setIndex(0);
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'No',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )),
                  ],
                );
              });
        },
      ));
    } else {
      loggedInUser = '👟Welcome';
    }

    //final size = MediaQuery.of(context).size; // > 650 is a bigger screen size like tablet and desktop
    final size = MediaQuery.sizeOf(context);

    const border = OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(225, 225, 225, 1)),
      borderRadius: BorderRadius.horizontal(left: Radius.circular(50.0)),
    );

    return Scaffold(
      appBar: AppBar(
          leading: null,
          title: Text(loggedInUser),
          centerTitle: true,
          actions: icons),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'CarryGo \nStore',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      icon: Icon(Icons.search),
                      border: border,
                      enabledBorder: border,
                      focusedBorder: border,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                // ListView.builder will take the entire height of the screen
                itemCount: filters.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      child: Chip(
                        backgroundColor: selectedFilter == filter
                            ? Theme.of(context).colorScheme.primary
                            : const Color.fromRGBO(245, 247, 249, 1),
                        side: const BorderSide(
                          color: Color.fromRGBO(245, 247, 249, 1),
                        ),
                        label: Text(filter),
                        labelStyle: TextStyle(fontSize: 16),
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: size.width > 650
                  ? GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ProductDetailsPage(product: product);
                            }));
                          },
                          child: ProductCard(
                            title: product['title'] as String,
                            price: product['price'] as double,
                            image: product['imageUrl'] as String,
                            backgroundColor: index.isEven
                                ? const Color.fromRGBO(216, 240, 253, 1)
                                : const Color.fromRGBO(245, 247, 249, 1),
                          ),
                        );
                      })
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return ProductDetailsPage(product: product);
                            }));
                          },
                          child: ProductCard(
                            title: product['title'] as String,
                            price: product['price'] as double,
                            image: product['imageUrl'] as String,
                            backgroundColor: index.isEven
                                ? const Color.fromRGBO(216, 240, 253, 1)
                                : const Color.fromRGBO(245, 247, 249, 1),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
