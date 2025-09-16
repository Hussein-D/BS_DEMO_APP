import 'dart:async';
import 'dart:developer';

import 'package:blank_street/models/shop.dart';
import 'package:blank_street/screens/map/shops_bottom_sheet.dart';
import 'package:blank_street/screens/shops/bloc/shops_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Position? _currentLocation;
  final Map<String, BitmapDescriptor> _icons = {};
  final Map<String, List<Placemark>> _placemarks = {};
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  Future<BitmapDescriptor> _buildStoreMarker({
    required String imageUrl,
    required String label,
    Color color = const Color(0xFF0E8A5C),
    double diameter = 96,
    double border = 6,
    double textBarHeight = 28,
    required double devicePixelRatio,
  }) async {
    final dpr = devicePixelRatio.clamp(1.0, 3.0);
    final size = (diameter * dpr).toInt();
    final textH = (textBarHeight * dpr).toInt();
    final bytes = (await http.get(Uri.parse(imageUrl))).bodyBytes;
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: size,
      targetHeight: size,
    );
    final frame = await codec.getNextFrame();
    final avatar = frame.image;

    final rec = ui.PictureRecorder();
    final canvas = Canvas(rec);
    final fullW = size;
    final fullH = size + textH + (12 * dpr).toInt();

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.18)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 12);
    final center = Offset(size / 2, size - 6 * dpr);
    canvas.drawCircle(center, size * 0.52, shadowPaint);

    // Avatar circle with border
    final outerR = size / 2.0;
    final innerR = outerR - border * dpr;
    final borderPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, outerR, borderPaint);

    // Clip & draw avatar
    final clipPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: innerR));
    canvas.save();
    canvas.clipPath(clipPath);
    final avatarRect = Rect.fromCircle(center: center, radius: innerR);
    final srcRect = Rect.fromLTWH(
      0,
      0,
      avatar.width.toDouble(),
      avatar.height.toDouble(),
    );
    canvas.drawImageRect(avatar, srcRect, avatarRect, Paint());
    canvas.restore();

    // Label bar
    final barRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        (fullW * 0.15),
        size + 6 * dpr,
        (fullW * 0.70),
        textH.toDouble(),
      ),
      Radius.circular(14 * dpr),
    );
    canvas.drawRRect(barRect, Paint()..color = color);

    // Label text (centered)
    final tp = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12 * dpr,
          fontWeight: FontWeight.w600,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: barRect.width);
    tp.paint(
      canvas,
      Offset(
        barRect.left + (barRect.width - tp.width) / 2,
        barRect.top + (barRect.height - tp.height) / 2,
      ),
    );

    final pic = rec.endRecording();
    final img = await pic.toImage(fullW, fullH);
    final pngBytes = (await img.toByteData(
      format: ui.ImageByteFormat.png,
    ))!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(pngBytes);
  }

  Future<void> _initLocation() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationServiceEnabled) {
      LocationPermission result = await Geolocator.checkPermission();
      if (result == LocationPermission.denied ||
          result == LocationPermission.deniedForever) {
        result = await Geolocator.requestPermission();
      }
      if (result == LocationPermission.denied ||
          result == LocationPermission.deniedForever) {
        return;
      } else {
        _currentLocation = await Geolocator.getCurrentPosition();
        setState(() {});
      }
    }
  }

  void _ensureIconFor(Shop s, BuildContext context) {
    if (_icons.containsKey(s.id)) return; // cached
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final double distance = Geolocator.distanceBetween(
      _currentLocation?.latitude ?? 0.0,
      _currentLocation?.longitude ?? 0.0,
      s.lat ?? 0.0,
      s.lon ?? 0.0,
    );
    _buildStoreMarker(
          imageUrl: 'https://i.pravatar.cc/128?u=${s.id}',
          label:
              '${(distance / 1000).toStringAsFixed(2)}km\n${(s.acceptingOrders ?? false) ? "Open" : "Close"}',
          devicePixelRatio: dpr,
        )
        .then((icon) {
          if (!mounted) return;
          setState(() => _icons[s.id!] = icon);
        })
        .catchError((_) {});
  }

  Future<void> _zoomOut() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.zoomOut());
  }

  Future<void> _recenterCamera() async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            _currentLocation?.latitude ?? 0.0,
            _currentLocation?.longitude ?? 0.0,
          ),
          zoom: 14,
        ),
      ),
    );
  }

  Future<void> _showBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      // backgroundColor: Theme.of(context).colorScheme.surface,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: BlocBuilder<ShopsBloc, ShopsState>(
          builder: (context, state) {
            if (state is ShopsInitial) {
              return const SizedBox();
            } else if (state is ShopsLoaded) {
              return ShopsBottomSheet(
                shops: state.shops,
                currentLocation: LatLng(
                  _currentLocation?.latitude ?? 0.0,
                  _currentLocation?.longitude ?? 0.0,
                ),
                placemarks: _placemarks,
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Future<void> _getShopsPlacemarks(List<Shop> shops) async {
    for (final Shop s in shops) {
      log("shop lat : ${s.lat}");
      try {
        _placemarks[s.id ?? ""] = await placemarkFromCoordinates(
          s.lat ?? 0.0,
          s.lon ?? 0.0,
        );
      } catch (e) {}
    }
  }

  @override
  void initState() {
    _initLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShopsBloc, ShopsState>(
      listener: (context, state) {
        if (state is ShopsLoaded && (state.isFirstTime ?? false)) {
          _getShopsPlacemarks(state.shops);
        }
      },
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 40,
          width: double.infinity,
          margin: const EdgeInsets.all(20),
          child: FilledButton(
            onPressed: _showBottomSheet,
            child: Text("View as list"),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _zoomOut,
          child: Icon(Icons.remove_rounded),
        ),
        body: Stack(
          children: [
            _currentLocation == null
                ? SpinKitFadingFour(
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : BlocBuilder<ShopsBloc, ShopsState>(
                    builder: (context, state) {
                      if (state is ShopsLoaded) {
                        final markers = <Marker>{
                          Marker(
                            markerId: MarkerId("current"),
                            position: LatLng(
                              _currentLocation?.latitude ?? 0.0,
                              _currentLocation?.longitude ?? 0.0,
                            ),
                          ),
                        };
                        for (final s in state.shops) {
                          _ensureIconFor(s, context);
                          markers.add(
                            Marker(
                              markerId: MarkerId(s.id ?? ''),
                              position: LatLng(s.lat ?? 0, s.lon ?? 0),
                              icon:
                                  _icons[s.id] ??
                                  BitmapDescriptor.defaultMarker,
                              anchor: const Offset(0.5, 1.0),
                              zIndexInt: 10,
                              onTap: () {
                                log("shops : ${s.name}");
                              },
                            ),
                          );
                        }
                        return GoogleMap(
                          onMapCreated: (controller) {
                            if (!_mapController.isCompleted) {
                              _mapController.complete(controller);
                            }
                          },
                          markers: markers,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              _currentLocation?.latitude ?? 0.0,
                              _currentLocation?.longitude ?? 0.0,
                            ),
                            zoom: 12,
                          ),
                        );
                      } else {
                        return SpinKitFadingFour(
                          size: 30,
                          color: Theme.of(context).colorScheme.primary,
                        );
                      }
                    },
                  ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _recenterCamera,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(Icons.near_me_rounded, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
