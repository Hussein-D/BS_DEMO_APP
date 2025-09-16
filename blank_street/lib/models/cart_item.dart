import 'package:blank_street/models/menu_item.dart';

class CartItem {
  final MenuItem item;
  final int quantity;
  const CartItem({required this.item, required this.quantity});
  CartItem copyWith({int? quantity}) =>
      CartItem(item: item, quantity: quantity ?? this.quantity);
  Map<String, dynamic> toMap() => {"item": item.toJson(), "quantity": quantity};
  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    item: MenuItem.fromJson(json["item"]),
    quantity: json["quantity"],
  );
}
