import 'dart:developer';

import 'package:blank_street/models/error_data_model.dart';
import 'package:blank_street/models/menu_item.dart';
import 'package:blank_street/models/option_choice.dart';
import 'package:blank_street/models/option_group.dart';
import 'package:blank_street/models/shop.dart';
import 'package:blank_street/screens/shops/repos/shops_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'shops_event.dart';
part 'shops_state.dart';

class ShopsBloc extends Bloc<ShopsEvent, ShopsState> {
  final ShopsRepo repo;
  List<Shop> _shops = [];
  List<MenuItem> _items = [];
  ShopsBloc({required this.repo}) : super(ShopsInitial()) {
    on<GetShops>((event, emit) async {
      if (state is! ShopsInitial) {
        emit(ShopsInitial());
      }
      final Either<ErrorDataModel, List<Shop>> result = await repo.getShops();
      result.fold((ErrorDataModel e) {}, (List<Shop> s) {
        _shops = s;
      });
      emit(ShopsLoaded(shops: _shops, items: _items));
    });
    on<GetShopMenu>((event, emit) async {
      emit(ShopsLoaded(shops: _shops, items: _items, isLoading: true));
      final Either<ErrorDataModel, List<MenuItem>> result = await repo
          .getShopMenu(shop: event.shop);
      result.fold((ErrorDataModel e) {}, (List<MenuItem> items) {
        _items = items;
      });
      emit(ShopsLoaded(shops: _shops, items: _items, isFirstTime: true));
    });
    on<SearchShops>((event, emit) {
      emit(ShopsLoaded(shops: _shops, items: _items, isLoading: true));
      emit(
        ShopsLoaded(
          shops: _shops
              .where(
                (e) =>
                    (e.name ?? "").toLowerCase().contains(event.query) ||
                    (e.address ?? "").toLowerCase().contains(event.query),
              )
              .toList(),
          items: _items,
          isLoading: true,
        ),
      );
    });
    on<ToggleGroupChoice>((event, emit) {
      emit(ShopsLoaded(shops: _shops, items: _items, isLoading: true));
      final int index = _items.indexOf(event.item);
      if (index != -1) {
        List<OptionGroup> groups = List.from(_items[index].optionGroups ?? []);
        final int groupIndex = groups.indexOf(event.group);
        int choiceIndex = -1;
        if (groupIndex != -1) {
          choiceIndex = (groups[groupIndex].choices ?? []).indexOf(
            event.choice,
          );
        }
        if (choiceIndex != -1) {
          if ((event.group.max ?? 1) == 1) {
            List<OptionChoice> choices =
                ((_items[index].optionGroups ?? [])[groupIndex].choices ?? [])
                    .map(
                      (e) => OptionChoice(
                        id: e.id,
                        name: e.name,
                        priceCents: e.priceCents,
                        isSelected: false,
                      ),
                    )
                    .toList();
            choices[choiceIndex] = choices[choiceIndex].copyWith(
              isSelected: !(event.choice.isSelected ?? false),
            );
            groups[groupIndex] = groups[groupIndex].copyWith(choices: choices);
            _items[index] = _items[index].copyWith(groups: groups);
          } else if ((event.group.max ?? 1) > 1) {
            final numberOfSelectedChoices =
                ((_items[index].optionGroups ?? [])[groupIndex].choices ?? [])
                    .where((e) => e.isSelected ?? false)
                    .length;
            if (numberOfSelectedChoices == (event.group.max ?? 1)) {
              List<OptionChoice> choices =
                  ((_items[index].optionGroups ?? [])[groupIndex].choices ?? [])
                      .map(
                        (e) => OptionChoice(
                          id: e.id,
                          name: e.name,
                          priceCents: e.priceCents,
                          isSelected: false,
                        ),
                      )
                      .toList();
              choices[choiceIndex] = choices[choiceIndex].copyWith(
                isSelected: !(event.choice.isSelected ?? false),
              );
              groups[groupIndex] = groups[groupIndex].copyWith(
                choices: choices,
              );
              _items[index] = _items[index].copyWith(groups: groups);
            } else {
              List<OptionChoice> choices = List.from(
                ((_items[index].optionGroups ?? [])[groupIndex].choices ?? []),
              );
              choices[choiceIndex] = choices[choiceIndex].copyWith(
                isSelected: !(event.choice.isSelected ?? false),
              );
              groups[groupIndex] = groups[groupIndex].copyWith(
                choices: choices,
              );
              _items[index] = _items[index].copyWith(groups: groups);
            }
          }
        }
      }
      emit(ShopsLoaded(shops: _shops, items: _items));
    });
  }
}
