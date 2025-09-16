part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class ClearCart extends CartEvent {}

class AddItemToCart extends CartEvent {
  final CartItem item;
  const AddItemToCart({required this.item});
}

class RemoveItemFromCart extends CartEvent {
  final CartItem item;
  const RemoveItemFromCart({required this.item});
}

class ModifyItemInCart extends CartEvent {
  final CartItem item;
  final int qunatity;
  const ModifyItemInCart({required this.item, required this.qunatity});
}
