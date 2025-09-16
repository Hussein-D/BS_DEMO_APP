import 'package:blank_street/screens/map/map_screen.dart';
import 'package:blank_street/screens/shops/view/shop_details_screen.dart';
import 'package:blank_street/screens/shops/bloc/shops_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopsScreen extends StatefulWidget {
  const ShopsScreen({super.key});

  @override
  State<ShopsScreen> createState() => _ShopsScreenState();
}

class _ShopsScreenState extends State<ShopsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Shops"),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 40),
          child: TextButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapScreen()),
            ),
            label: Text("Location"),
            icon: Icon(Icons.keyboard_arrow_down_rounded),
          ),
        ),
      ),
      body: BlocBuilder<ShopsBloc, ShopsState>(
        builder: (context, state) {
          if (state is ShopsInitial) {
            return const SizedBox();
          } else if (state is ShopsLoaded) {
            return RefreshIndicator.adaptive(
              onRefresh: () async => context.read<ShopsBloc>().add(GetShops()),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.shops.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ShopDetailsScreen(shop: state.shops[index]),
                    ),
                  ),
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    child: Icon(Icons.coffee_rounded),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text(state.shops[index].name ?? ""),
                  subtitle: Text(state.shops[index].address ?? ""),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
