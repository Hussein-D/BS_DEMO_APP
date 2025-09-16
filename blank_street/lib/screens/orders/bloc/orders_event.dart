part of 'orders_bloc.dart';

sealed class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class PlaceOrder extends OrdersEvent {
  final Order order;
  const PlaceOrder({required this.order});
}

class GetOrders extends OrdersEvent {
  final String userId;
  const GetOrders({required this.userId});
}

class TrackOrder extends OrdersEvent {
  final Order order;
  const TrackOrder({required this.order});
}

class StopTracking extends OrdersEvent {
  const StopTracking();
}

class OnSnapshot extends OrdersEvent {
  final Order order;
  const OnSnapshot(this.order);
}

class OnUpdate extends OrdersEvent {
  final Order order;
  const OnUpdate(this.order);
}

class OnLocation extends OrdersEvent {
  final Courier courier;
  const OnLocation(this.courier);
}

class OnConnection extends OrdersEvent {
  final bool connected;
  const OnConnection(this.connected);
}

class OnError extends OrdersEvent {
  final String message;
  const OnError(this.message);
}
