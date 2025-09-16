part of 'orders_bloc.dart';

class OrdersState extends Equatable {
  final String? orderId;
  final String? status;
  final bool delivered;
  final Courier? courier;
  final int? etaSeconds;
  final double? progress;
  final Order? order;
  final String? error;
  final String? message;
  final List<Order>? orders;
  final bool? isLoading;

  const OrdersState({
    this.orderId,
    this.status,
    this.isLoading,
    this.delivered = false,
    this.courier,
    this.etaSeconds,
    this.progress,
    this.order,
    this.error,
    this.orders,
    this.message,
  });

  const OrdersState.initial()
    : orderId = null,
      status = 'pending',
      delivered = false,
      courier = null,
      etaSeconds = null,
      progress = null,
      order = null,
      orders = null,
      message = null,
      isLoading = null,
      error = null;

  OrdersState copyWith({
    String? orderId,
    String? status,
    bool? delivered,
    Courier? courier,
    int? etaSeconds,
    double? progress,
    Order? order,
    String? error,
    String? message,
    List<Order>? orders,
    bool? isLoading,
  }) {
    return OrdersState(
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      delivered: delivered ?? this.delivered,
      courier: courier ?? this.courier,
      etaSeconds: etaSeconds ?? this.etaSeconds,
      progress: progress ?? this.progress,
      order: order ?? this.order,
      message: message ?? this.message,
      error: error,
      isLoading: isLoading ?? this.isLoading,
      orders: List.from(orders ?? this.orders ?? []),
    );
  }

  @override
  List<Object?> get props => [
    orderId,
    status,
    delivered,
    courier,
    etaSeconds,
    progress,
    order,
    error,
    message,
    isLoading,
    orders,
  ];
}
