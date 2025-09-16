import 'dart:convert';

import 'package:blank_street/models/cart_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CartRepo {
  Future<List<CartItem>> loadCart();
  Future<void> clearCart();
  Future<void> addItemToCart({required CartItem item});
  Future<void> removeItemFromCart({required CartItem item});
  Future<void> modifyItemInCart({
    required CartItem item,
    required int quantity,
  });
}

class CartRepoImpl implements CartRepo {
  @override
  Future<void> addItemToCart({required CartItem item}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<CartItem> items = await loadCart();
    items.add(item);
    await prefs.setString("cart", jsonEncode(items.map((e) => e.toMap()).toList()));
  }

  @override
  Future<void> clearCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("cart");
  }

  @override
  Future<List<CartItem>> loadCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cartAsString = prefs.getString("cart");
    if (cartAsString != null) {
      final List<CartItem> items = (jsonDecode(cartAsString) as List? ?? [])
          .map((e) => CartItem.fromJson(e))
          .toList();
      return items;
    }
    return [];
  }

  @override
  Future<void> modifyItemInCart({
    required CartItem item,
    required int quantity,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<CartItem> items = await loadCart();
    final int index = items.indexWhere((e) => e.item.id == item.item.id);
    if (index != -1) {
      items[index] = items[index].copyWith(quantity: quantity);
    }
    await prefs.setString("cart", jsonEncode(items.map((e) => e.toMap()).toList()));
  }

  @override
  Future<void> removeItemFromCart({required CartItem item}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<CartItem> items = await loadCart();
    items.removeWhere((e) => e.item.id == item.item.id);
    await prefs.setString("cart", jsonEncode(items.map((e) => e.toMap()).toList()));
  }
}
