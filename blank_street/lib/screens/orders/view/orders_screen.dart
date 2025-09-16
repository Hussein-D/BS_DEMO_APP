import 'dart:developer';

import 'package:blank_street/models/order.dart';
import 'package:blank_street/screens/orders/bloc/orders_bloc.dart';
import 'package:blank_street/screens/orders/view/orders_loading_screen.dart';
import 'package:blank_street/screens/orders/view/track_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    context.read<OrdersBloc>().add(GetOrders(userId: "demo-user"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Orders")),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state.isLoading ?? false) {
            return OrdersLoadingScreen();
          } else if ((state.orders ?? []).isNotEmpty) {
            return RefreshIndicator.adaptive(
              onRefresh: () async => context.read<OrdersBloc>().add(
                GetOrders(userId: "demo-user"),
              ),
              child: ListView.builder(
                itemCount: (state.orders ?? []).length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (contxet, index) => Card(
                  child: ListTile(
                    shape: RoundedRectangleBorder(),
                    subtitle: Text(state.orders?[index].status ?? ""),
                    onTap: () async {
                      final Position position =
                          await Geolocator.getCurrentPosition();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderTrackingWsScreen(
                            order: state.orders?[index] ?? const Order(),
                            shop: LatLng(40.75538, -73.97456),
                            destination: LatLng(
                              position.latitude,
                              position.longitude,
                            ),
                          ),
                        ),
                      );
                    },
                    title: Text(
                      "Order# ${state.orders?[index].id} : \$${((state.orders?[index].subtotalCents ?? 0) / 100).toStringAsFixed(2)}",
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  ),
                ),
              ),
            );
          } else {
            return Center(child: Text("No orders yet"));
          }
        },
      ),
    );
  }
}
