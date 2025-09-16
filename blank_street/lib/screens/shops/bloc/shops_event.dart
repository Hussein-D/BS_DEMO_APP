part of 'shops_bloc.dart';

sealed class ShopsEvent extends Equatable {
  const ShopsEvent();

  @override
  List<Object> get props => [];
}

class GetShops extends ShopsEvent {
  const GetShops();
}

class GetShopMenu extends ShopsEvent {
  final Shop shop;
  const GetShopMenu({required this.shop});
}

class SearchShops extends ShopsEvent {
  final String query;
  const SearchShops({required this.query});
}

class ToggleGroupChoice extends ShopsEvent {
  final OptionGroup group;
  final OptionChoice choice;
  final MenuItem item;
  const ToggleGroupChoice({
    required this.group,
    required this.choice,
    required this.item,
  });
}
