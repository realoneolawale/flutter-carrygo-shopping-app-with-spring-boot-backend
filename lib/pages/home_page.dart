import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/pages/cart_page.dart';
import 'package:shopping_app/pages/login_page.dart';
import 'package:shopping_app/pages/register_page.dart';
import 'package:shopping_app/provider/cart_provider.dart';
import 'package:shopping_app/provider/navigation_provider.dart';
import 'package:shopping_app/widgets/product_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final user = Provider.of<CartProvider>(context).user;
    List<Widget> pages = [
      ProductList(),
      CartPage(),
    ];
    List<BottomNavigationBarItem> items = [
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
    ];

    //print("USER: " + user.firstName);

    if (!user.firstName.isNotEmpty) {
      pages.add(RegisterPage());
      pages.add(LoginPage());

      items.addAll([
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
      ]);
    }

    return Scaffold(
      //body: pages[currentPage],
      body: IndexedStack(
        // helps maintain the scroll position
        index: navigationProvider.currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 35,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        onTap: (value) {
          navigationProvider.setIndex(value);
        },
        currentIndex:
            navigationProvider.currentIndex, // currently selected page
        items: items,
      ),
    );
  }
}
