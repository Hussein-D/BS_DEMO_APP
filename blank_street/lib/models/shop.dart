import 'package:blank_street/models/opening_hours.dart';
import 'package:equatable/equatable.dart';

class Shop extends Equatable {
  final String? id;
  final String? name;
  final double? lat;
  final double? lon;
  final String? address;
  final bool? acceptingOrders;
  final OpeningHours? openingHours;
  final String? imageUrl;
  const Shop({
    this.acceptingOrders,
    this.address,
    this.id,
    this.lat,
    this.lon,
    this.name,
    this.openingHours,
    this.imageUrl,
  });
  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json["id"],
      acceptingOrders: json["acceptingOrders"],
      address: json["address"],
      imageUrl: json["imageUrl"],
      lat: json["lat"],
      lon: json["lon"],
      name: json["name"],
      openingHours: json["openingHours"] != null
          ? OpeningHours.fromJson(json["openingHours"])
          : null,
    );
  }
  @override
  List<String?> get props => [id];
}
