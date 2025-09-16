import 'dart:async';
import 'dart:developer';

import 'package:blank_street/models/courier.dart';
import 'package:blank_street/models/error_data_model.dart';
import 'package:blank_street/models/order.dart';
import 'package:blank_street/screens/orders/repo/orders_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepo repo;
  List<Order> _orders = [];
  StreamSubscription? _sub;
  OrdersBloc(this.repo) : super(OrdersState.initial()) {
    on<GetOrders>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      String message = "";
      final dartz.Either<ErrorDataModel, List<Order>> result = await repo
          .getOrders(userId: event.userId);
      result.fold(
        (ErrorDataModel e) {
          message = "Error";
        },
        (List<Order> r) {
          _orders = r;
          message = "Success";
        },
      );
      emit(state.copyWith(message: message, orders: _orders, isLoading: false));
    });
    on<PlaceOrder>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      String message = "";
      final dartz.Either<ErrorDataModel, void> result = await repo.placeOrder(
        order: event.order,
      );
      result.fold(
        (ErrorDataModel e) {
          message = "Error";
          log("an error occured while placing the order : ${e.message}");
        },
        (r) {
          message = "Success";
          log("order went through successfully");
        },
      );
      emit(state.copyWith(message: message, orders: _orders, isLoading: false));
    });
    on<OnSnapshot>((event, emit) {
      emit(
        state.copyWith(
          status: event.order.status ?? state.status,
          order: event.order,
          delivered: event.order.status == 'delivered',
          error: null,
        ),
      );
    });
    on<OnLocation>((event, emit) {
      emit(
        state.copyWith(
          courier: event.courier,
          etaSeconds: event.courier.etaSeconds,
          progress: event.courier.progress,
          error: null,
        ),
      );
    });
    on<OnUpdate>((event, emit) {
      emit(
        state.copyWith(
          status: event.order.status ?? state.status,
          order: event.order,
          delivered: state.order?.status == 'delivered',
          error: null,
        ),
      );
    });
    on<OnError>((event, emit) {
      emit(state.copyWith(error: event.message));
    });
    on<OnConnection>((event, emit) {
      emit(state.copyWith());
    });
    on<TrackOrder>((event, emit) async {
      _sub?.cancel();
      _sub = repo.watchOrderUpdates(order: event.order).listen((evt) {
        switch (evt) {
          case SnapshotEvent(:final order):
            add(OnSnapshot(order));
            break;
          case UpdateEvent(:final order):
            add(OnUpdate(order));
            break;
          case LocationEvent(:final courier):
            add(OnLocation(courier));
            break;
          case ConnectionEvent(:final connected):
            add(OnConnection(connected));
            break;
          case ErrorEvent(:final message):
            add(OnError(message));
            break;
        }
      });
    });
  }
  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}
