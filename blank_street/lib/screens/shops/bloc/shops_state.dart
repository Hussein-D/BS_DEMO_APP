part of 'shops_bloc.dart';

sealed class ShopsState extends Equatable {
  const ShopsState();

  @override
  List<bool?> get props => [];
}

final class ShopsInitial extends ShopsState {}

class ShopsLoaded extends ShopsState {
  final List<Shop> shops;
  final List<MenuItem> items;
  final bool? isLoading;
  final bool? isFirstTime;
  const ShopsLoaded({
    required this.shops,
    required this.items,
    this.isLoading,
    this.isFirstTime,
  });
  @override
  List<bool?> get props => [isLoading];
}
