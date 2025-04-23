import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/dtos/auth_response_dto.dart';
import 'package:shopping_app/dtos/category_response_dto.dart';
import 'package:shopping_app/dtos/product_response_dto.dart';
import 'package:shopping_app/provider/cart_provider.dart';
import 'package:shopping_app/services/networking.dart';
import 'package:shopping_app/services/sharedpreferences.dart';
import 'package:shopping_app/widgets/product_card.dart';

import '../pages/product_details_page.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});
  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  // product and categories from db
  List<CategoryResponseDto> _categories = [
    CategoryResponseDto(name: 'All', id: 0)
  ];
  List<ProductResponseDto> products = [];

  late String selectedFilter;
  late String loggedInUser;
  late AuthResponseDto authResponseUser = AuthResponseDto(
      accessToken: '',
      tokenType: '',
      id: 0,
      firstName: '',
      email: '',
      username: '');
  int? categoryId;
  static const String imageBaseUrl = 'http://192.168.0.175:40160/';

  // set the authenticated user in the shared
  setAuthenticatedUser() async {
    // set the authenticated user in the provider
    final userDto = context.watch<CartProvider>().getAuthResponseDto;
    if (userDto != null) {
      if (userDto.firstName!.isNotEmpty) {
        print("USER GOTTEN FROM PROVIDER");
        authResponseUser.tokenType = userDto.tokenType;
        authResponseUser.accessToken = userDto.accessToken;
        authResponseUser.id = userDto.id;
        authResponseUser.firstName = userDto.firstName;
        authResponseUser.email = userDto.email;
        authResponseUser.username = userDto.username;
      }
    } else {
      // if user is not in the provider
      if (SharedPreferenceHelper().getUsername().toString().length > 1) {
        //print("USER GOTTEN FROM SHARED PREFERENCES");
        // set the user from the shared preferences
        authResponseUser.tokenType =
            await SharedPreferenceHelper().getTokenType() ?? "";
        authResponseUser.accessToken =
            await SharedPreferenceHelper().getAccessTokenId() ?? "";
        authResponseUser.id = await SharedPreferenceHelper().getId() ?? 0;
        authResponseUser.firstName =
            await SharedPreferenceHelper().getFirstName() ?? "";
        authResponseUser.email =
            await SharedPreferenceHelper().getEmail() ?? "";
        authResponseUser.username =
            await SharedPreferenceHelper().getUsername() ?? "";
      }
    }
  }

  getCategories() async {
    List<CategoryResponseDto> dbCategories =
        await NetworkHelper().getCategories();
    _categories.addAll(dbCategories);
  }

  @override
  void initState() {
    getCategories(); // load the categories when the page loads
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // set the user
    setAuthenticatedUser();
    // logged in user icons
    List<Widget> icons = [];
    // track the selected category
    selectedFilter = _categories[0].name;
    // set the logged in user header
    if (context.read<CartProvider>().getAuthResponseDto != null) {
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
                      onPressed: () async {
                        Navigator.of(context).pop();
                        // clear shared preferences
                        await SharedPreferenceHelper().clearSharedPreference();
                        // redirect to the product list tab
                        // clear the provider than authenticated user
                        context.read<CartProvider>().clearAuthResponseDto();
                        context.read<CartProvider>().logout();
                        context.read<CartProvider>().setTab(0);
                        print("USER IS LOGGED OUT!!!!");
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
                    //onChanged: () {},
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
                itemCount: _categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final filter = _categories[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = filter.name;
                          categoryId = filter.id;
                        });
                      },
                      child: Chip(
                        backgroundColor: selectedFilter == filter.name
                            ? Theme.of(context).colorScheme.primary
                            : const Color.fromRGBO(245, 247, 249, 1),
                        side: const BorderSide(
                          color: Color.fromRGBO(245, 247, 249, 1),
                        ),
                        label: Text(filter.name),
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
                  ? FutureBuilder<List<ProductResponseDto>>(
                      future: NetworkHelper().getProducts(categoryId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('No products found');
                        }
                        final products = snapshot.data!;

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final productImageUrl =
                                '$imageBaseUrl${product.imageUrl}';
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return ProductDetailsPage(product: product);
                                }));
                              },
                              child: ProductCard(
                                title: product.name,
                                price: double.parse(product.price.toString()),
                                image: productImageUrl,
                                backgroundColor: index.isEven
                                    ? const Color.fromRGBO(216, 240, 253, 1)
                                    : const Color.fromRGBO(245, 247, 249, 1),
                              ),
                            );
                          },
                        );
                      },
                    )
                  : FutureBuilder<List<ProductResponseDto>>(
                      future: NetworkHelper().getProducts(categoryId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('No products found');
                        }
                        final products = snapshot.data!;

                        return ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            final productImageUrl =
                                '$imageBaseUrl${product.imageUrl}';
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return ProductDetailsPage(product: product);
                                }));
                              },
                              child: ProductCard(
                                title: product.name,
                                price: double.parse(product.price.toString()),
                                image: productImageUrl,
                                backgroundColor: index.isEven
                                    ? const Color.fromRGBO(216, 240, 253, 1)
                                    : const Color.fromRGBO(245, 247, 249, 1),
                              ),
                            );
                          },
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
