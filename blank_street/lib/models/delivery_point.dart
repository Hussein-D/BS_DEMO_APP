class DeliveryPoint {
  final double? lat;
  final double? lon;

  const DeliveryPoint({this.lat, this.lon});

  factory DeliveryPoint.fromJson(Map<String, dynamic> j) => DeliveryPoint(
    lat: (j['lat'] as num?)?.toDouble(),
    lon: (j['lon'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {'lat': lat, 'lon': lon};
}
