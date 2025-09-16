import 'dart:async';
import 'dart:convert';

import 'package:blank_street/core/type_defs/api_service_output.dart';
import 'package:blank_street/models/courier.dart';
import 'package:blank_street/models/order.dart';
import 'package:blank_street/network/api_service.dart';
import 'package:blank_street/screens/orders/repo/orders_endpoints.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OrderStreamEvent {
  const OrderStreamEvent();
}

class SnapshotEvent extends OrderStreamEvent {
  final Order order;
  const SnapshotEvent(this.order);
}

class UpdateEvent extends OrderStreamEvent {
  final Order order;
  const UpdateEvent(this.order);
}

class LocationEvent extends OrderStreamEvent {
  final Courier courier;
  const LocationEvent(this.courier);
}

class ConnectionEvent extends OrderStreamEvent {
  final bool connected;
  const ConnectionEvent(this.connected);
}

class ErrorEvent extends OrderStreamEvent {
  final String message;
  const ErrorEvent(this.message);
}

abstract class OrdersRepo {
  ApiServiceOutput<void> placeOrder({required Order order});
  ApiServiceOutput<List<Order>> getOrders({required String userId});
  Stream<OrderStreamEvent> watchOrderUpdates({required Order order});
}

class OrdersRepoImpl implements OrdersRepo {
  @override
  ApiServiceOutput<void> placeOrder({required Order order}) async {
    return await ApiService().postRequest(
      endpoint: OrdersEndpoints.placeOrder.getStringPresentation(),
      fromJson: (p0) {},
      bodyData: order.toJson(),
    );
  }

  @override
  ApiServiceOutput<List<Order>> getOrders({required String userId}) async {
    return await ApiService().getList(
      endpoint: OrdersEndpoints.getUserOrders.getStringPresentation(
        userId: userId,
      ),
      fromJson: Order.fromJson,
    );
  }

  @override
  Stream<OrderStreamEvent> watchOrderUpdates({required Order order}) {
    WebSocketChannel? channel;
    final _controller = StreamController<OrderStreamEvent>.broadcast();
    final uri = Uri.parse('ws://127.0.0.1:4000/ws');
    channel = WebSocketChannel.connect(uri);
    channel.sink.add(jsonEncode({'type': 'subscribe', 'orderId': order.id}));
    _controller.add(ConnectionEvent(true));
    channel.stream.listen(
      (raw) {
        final msg = jsonDecode(raw as String) as Map<String, dynamic>;
        final type = msg['type'] as String?;
        final data = msg['data'];

        switch (type) {
          case 'snapshot':
            _controller.add(
              SnapshotEvent(Order.fromJson(Map<String, dynamic>.from(data))),
            );
            break;
          case 'update':
            final order = Order.fromJson(Map<String, dynamic>.from(data));
            _controller.add(UpdateEvent(order));
            if (order.status == 'delivered') {
              // _stopPolling();
            }
            break;
          case 'location':
            final courier = Courier.fromJson(
              Map<String, dynamic>.from(data['courier']),
            );
            _controller.add(LocationEvent(courier));
            break;
          case 'error':
            _controller.add(
              ErrorEvent((data?['message'] ?? 'error').toString()),
            );
            break;
        }
      },
      onDone: () {
        _controller.add(ConnectionEvent(false));
      },
      onError: (e) {
        _controller.add(ErrorEvent(e.toString()));
        _controller.add(ConnectionEvent(false));
      },
    );
    return _controller.stream;
  }
}
