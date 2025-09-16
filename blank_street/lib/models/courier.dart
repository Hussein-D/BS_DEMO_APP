import 'package:blank_street/models/delivery_point.dart';

class Courier {
  final DeliveryPoint? location;
  final double? bearing;
  final int? etaSeconds;
  final double? progress;

  const Courier({this.location, this.bearing, this.etaSeconds, this.progress});

  factory Courier.fromJson(Map<String, dynamic> j) => Courier(
    location: j['location'] is Map<String, dynamic>
        ? DeliveryPoint.fromJson(j['location'] as Map<String, dynamic>)
        : null,
    bearing: (j['bearing'] as num?)?.toDouble(),
    etaSeconds: (j['etaSeconds'] as num?)?.toInt(),
    progress: (j['progress'] as num?)?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'location': location?.toJson(),
    'bearing': bearing,
    'etaSeconds': etaSeconds,
    'progress': progress,
  };
}
