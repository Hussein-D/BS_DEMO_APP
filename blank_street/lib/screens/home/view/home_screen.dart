import 'package:blank_street/screens/gifts_wallet/view/gifts_wallet_screen.dart';
import 'package:blank_street/screens/main_home/view/main_home_screen.dart';
import 'package:blank_street/screens/map/map_screen.dart';
import 'package:blank_street/screens/orders/view/orders_screen.dart';
import 'package:blank_street/screens/regulars/view/regulars_screen.dart';
import 'package:blank_street/screens/shops/view/shops_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (value) => setState(() {
          _index = value;
        }),
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.near_me_rounded),
            label: "Near me",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sentiment_very_satisfied_rounded),
            label: "Regulars",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_rounded),
            label: "Orders",
          ),
        ],
      ),
      body: IndexedStack(
        index: _index,
        children: [
          MainHomeScreen(),
          MapScreen(),
          ShopsScreen(),
          OrdersScreen(),
        ],
      ),
    );
  }
}
