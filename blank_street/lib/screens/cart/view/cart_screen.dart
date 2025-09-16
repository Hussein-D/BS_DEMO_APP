import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blank_street/models/option_choice.dart';
import 'package:blank_street/models/option_group.dart';
import 'package:blank_street/models/order.dart';
import 'package:blank_street/screens/cart/bloc/cart_bloc.dart';
import 'package:blank_street/screens/orders/bloc/orders_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state.message != null) {
          AwesomeDialog(
            context: context,
            dialogType: (state.message ?? "").toLowerCase().contains("error")
                ? DialogType.error
                : DialogType.success,
            title: (state.message ?? "").toLowerCase().contains("error")
                ? "Error"
                : "Success",
            desc: (state.message ?? "").toLowerCase().contains("error")
                ? "Error placing your order"
                : "Your order went through",
            autoHide: const Duration(seconds: 2),
            onDismissCallback: (_) {
              if (!(state.message ?? "").toLowerCase().contains("error") &&
                  context.mounted) {
                context.read<CartBloc>().add(ClearCart());
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              }
            },
          ).show();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Cart")),
        bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded) {
              return Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                child: BlocBuilder<OrdersBloc, OrdersState>(
                  builder: (context, orderState) {
                    return FilledButton(
                      onPressed: () async {
                        if (orderState.isLoading ?? false) {
                          return;
                        }
                        final Position position =
                            await Geolocator.getCurrentPosition();
                        context.read<OrdersBloc>().add(
                          PlaceOrder(
                            order: Order(
                              deliverTo: LatLng(
                                position.latitude,
                                position.longitude,
                              ),
                              items: state.items,
                              userId: "demo-user",
                            ),
                          ),
                        );
                      },
                      child: (orderState.isLoading ?? false)
                          ? SpinKitThreeBounce(color: Colors.white, size: 25)
                          : Text("Go to checkout"),
                    );
                  },
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoaded) {
              return ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  String options = "";
                  double total = 0;
                  for (final OptionGroup g
                      in state.items[index].item.optionGroups ?? []) {
                    for (final OptionChoice c in (g.choices ?? [])) {
                      if (c.isSelected ?? false) {
                        options +=
                            ".${c.name ?? ""} \$${(c.priceCents ?? 0) / 100} \n";
                        total +=
                            ((c.priceCents ?? 0) / 100) *
                            state.items[index].quantity;
                      }
                    }
                  }
                  total +=
                      state.items[index].quantity *
                      ((state.items[index].item.basePriceCents ?? 0) / 100);
                  return ListTile(
                    title: Text(
                      "${state.items[index].item.name ?? ""} \$${total.toStringAsFixed(2)}",
                    ),
                    subtitle: Text(
                      "${state.items[index].item.description ?? ""}\n$options",
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (state.items[index].quantity == 1) {
                              context.read<CartBloc>().add(
                                RemoveItemFromCart(item: state.items[index]),
                              );
                            } else {
                              context.read<CartBloc>().add(
                                ModifyItemInCart(
                                  item: state.items[index],
                                  qunatity: state.items[index].quantity - 1,
                                ),
                              );
                            }
                          },
                          icon: state.items[index].quantity == 1
                              ? Icon(Icons.delete)
                              : Icon(Icons.remove_rounded),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          state.items[index].quantity.toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            context.read<CartBloc>().add(
                              ModifyItemInCart(
                                item: state.items[index],
                                qunatity: state.items[index].quantity + 1,
                              ),
                            );
                          },
                          icon: Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
