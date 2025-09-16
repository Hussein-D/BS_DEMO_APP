import 'package:blank_street/models/cart_item.dart';
import 'package:blank_street/screens/cart/repo/cart_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepo repo;
  List<CartItem> _items = [];
  CartBloc(this.repo) : super(CartInitial()) {
    on<LoadCart>((event, emit) async {
      if (state is! CartInitial) {
        emit(CartInitial());
      }
      _items = await repo.loadCart();
      emit(CartLoaded(items: _items));
    });
    on<AddItemToCart>((event, emit) async {
      emit(CartLoaded(items: _items, isLoading: true));
      await repo.addItemToCart(item: event.item);
      _items = await repo.loadCart();
      emit(CartLoaded(items: _items));
    });
    on<RemoveItemFromCart>((event, emit) async {
      emit(CartLoaded(items: _items, isLoading: true));
      await repo.removeItemFromCart(item: event.item);
      _items = await repo.loadCart();
      emit(CartLoaded(items: _items));
    });
    on<ModifyItemInCart>((event, emit) async {
      emit(CartLoaded(items: _items, isLoading: true));
      await repo.modifyItemInCart(item: event.item, quantity: event.qunatity);
      _items = await repo.loadCart();
      emit(CartLoaded(items: _items));
    });
    on<ClearCart>((event, emit) async {
      emit(CartLoaded(items: _items, isLoading: true));
      await repo.clearCart();
      _items = await repo.loadCart();
      emit(CartLoaded(items: _items));
    });
  }
}
