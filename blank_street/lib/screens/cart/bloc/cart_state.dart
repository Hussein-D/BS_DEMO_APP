part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<bool?> get props => [];
}

final class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final bool? isLoading;
  const CartLoaded({required this.items, this.isLoading});
  @override
  List<bool?> get props => [isLoading];
}
