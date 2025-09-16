import 'package:blank_street/models/order.dart';
import 'package:blank_street/screens/orders/bloc/orders_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingWsScreen extends StatefulWidget {
  const OrderTrackingWsScreen({
    required this.shop,
    this.destination,
    required this.order,
  });
  final LatLng shop;
  final LatLng? destination;
  final Order order;

  @override
  State<OrderTrackingWsScreen> createState() => _OrderTrackingViewState();
}

class _OrderTrackingViewState extends State<OrderTrackingWsScreen> {
  GoogleMapController? _map;

  @override
  void initState() {
    context.read<OrdersBloc>().add(TrackOrder(order: widget.order));
    super.initState();
  }

  @override
  void dispose() {
    _map?.dispose();
    super.dispose();
  }

  Future<void> _zoomOut() async {
    _map?.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    final mid = widget.destination == null
        ? widget.shop
        : LatLng(
            (widget.shop.latitude + widget.destination!.latitude) / 2,
            (widget.shop.longitude + widget.destination!.longitude) / 2,
          );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _zoomOut,
        child: Icon(Icons.remove_rounded),
      ),
      appBar: AppBar(
        title: BlocBuilder<OrdersBloc, OrdersState>(
          buildWhen: (a, b) => a.status != b.status,
          builder: (_, s) => Text('Track • ${s.status ?? '—'}'),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          final markers = <Marker>{
            Marker(
              markerId: const MarkerId('shop'),
              position: widget.shop,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
              infoWindow: const InfoWindow(title: 'Shop'),
            ),
          };
          if (widget.destination != null) {
            markers.add(
              Marker(
                markerId: const MarkerId('dest'),
                position: widget.destination!,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueAzure,
                ),
                infoWindow: const InfoWindow(title: 'Destination'),
              ),
            );
          }
          if (state.courier?.location != null) {
            final p = state.courier!.location!;
            markers.add(
              Marker(
                markerId: const MarkerId('courier'),
                position: LatLng(p.lat ?? 0, p.lon ?? 0),
                rotation: state.courier!.bearing ?? 0,
                flat: true,
                anchor: const Offset(0.5, 0.5),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
              ),
            );

            // keep camera on courier lightly
            _map?.animateCamera(
              CameraUpdate.newLatLng(LatLng(p.lat ?? 0, p.lon ?? 0)),
            );
          }

          final etaText = (state.etaSeconds == null)
              ? '—'
              : '${(state.etaSeconds! / 60).floor()}m ${state.etaSeconds! % 60}s';

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(target: mid, zoom: 13),
                onMapCreated: (c) => _map = c,
                myLocationButtonEnabled: false,
                compassEnabled: false,
                markers: markers,
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: _StatusCard(
                  status: state.status ?? '—',
                  eta: etaText,
                  error: state.error,
                ),
              ),
            ],
          );
        },
      ),
      backgroundColor: const Color(0xFFFCF7F2),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.status, required this.eta, this.error});
  final String status;
  final String eta;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Status: ${_title(status)}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 10),
          Text('ETA $eta', style: const TextStyle(fontWeight: FontWeight.w700)),
          if (error != null) ...[
            const SizedBox(width: 8),
            Icon(Icons.info_outline, color: Colors.red.shade300, size: 18),
          ],
        ],
      ),
    );
  }

  static String _title(String s) {
    final t = s.trim();
    return t.isEmpty
        ? '—'
        : t[0].toUpperCase() + t.substring(1).replaceAll('_', ' ');
  }
}
