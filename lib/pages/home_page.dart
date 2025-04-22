import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/pages/cart_page.dart';
import 'package:shopping_app/pages/login_page.dart';
import 'package:shopping_app/pages/register_page.dart';
import 'package:shopping_app/provider/cart_provider.dart';
import 'package:shopping_app/widgets/product_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    int _currentIndex = context.watch<CartProvider>().currentIndex;

    final isLoggedIn = context.watch<CartProvider>().isLoggedIn;

    final pages = isLoggedIn
        ? [ProductList(), CartPage()]
        : [ProductList(), CartPage(), RegisterPage(), LoginPage()];

    final navItems = isLoggedIn
        ? [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.black,
              ),
              label: '',
            )
          ]
        : [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.black,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.login,
                color: Colors.black,
              ),
              label: '',
            )
          ];

    final safeIndex = _currentIndex.clamp(0, navItems.length - 1);

    // get the providers
    final user = Provider.of<CartProvider>(context).getAuthResponseDto;

    return Scaffold(
      //body: pages[currentPage],
      body: IndexedStack(
        // helps maintain the scroll position
        index: safeIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 35,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        onTap: (index) => context.read<CartProvider>().setTab(index),
        currentIndex: safeIndex, // currently selected page
        items: navItems,
      ),
    );
  }
}
