import 'package:blank_street/models/cart_item.dart';
import 'package:blank_street/models/courier.dart';
import 'package:blank_street/models/delivery_point.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Order {
  final String? id;
  final String? userId;
  final String? shopId;
  final DateTime? createdAt;
  final DateTime? scheduledAt;
  final DeliveryPoint? deliveryTo;
  final int? subtotalCents;
  final int? taxCents;
  final int? totalCents;
  final String? status;
  final String? paymentStatus;
  final Courier? courier;
  final List<CartItem>? items;
  final LatLng? deliverTo;
  const Order({
    this.deliverTo,
    this.items,
    this.shopId,
    this.userId,
    this.id,
    this.createdAt,
    this.scheduledAt,
    this.deliveryTo,
    this.subtotalCents,
    this.taxCents,
    this.totalCents,
    this.status,
    this.paymentStatus,
    this.courier,
  });
  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'] as String?,
    userId: json['userId'] as String?,
    shopId: json['shopId'] as String?,
    deliveryTo: json['deliveryTo'] is Map<String, dynamic>
        ? DeliveryPoint.fromJson(json['deliveryTo'] as Map<String, dynamic>)
        : null,
    subtotalCents: (json['subtotalCents'] as num?)?.toInt(),
    taxCents: (json['taxCents'] as num?)?.toInt(),
    totalCents: (json['totalCents'] as num?)?.toInt(),
    status: json['status'] as String?,
    paymentStatus: json['paymentStatus'] as String?,
    courier: json['courier'] is Map<String, dynamic>
        ? Courier.fromJson(json['courier'] as Map<String, dynamic>)
        : null,
  );
  Map<String, dynamic> toJson() => {
    "userId": userId,
    "shopId": "us_ny_48th_lex",
    "items": (items ?? [])
        .map(
          (e) => {
            "itemId": e.item.id,
            "quantity": e.quantity,
            "selected": {
              "size": ["md"],
              "milk": ["oat"],
              "shots": ["x1"],
              "sweet": ["vanilla"],
            },
          },
        )
        .toList(),
    "deliveryTo": {"lat": deliverTo?.latitude, "lon": deliverTo?.longitude},
  };
}
