import 'package:blank_street/models/menu_item.dart';
import 'package:blank_street/models/shop.dart';
import 'package:blank_street/screens/shops/bloc/shops_bloc.dart';
import 'package:blank_street/screens/shops/view/menu_item_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final Color cream = Color(0xFFFCF7F2);
final Color beige = Color(0xFFECDBCB);
final Color green = Color(0xFF0E8A5C);
final Color textPrimary = Color(0xFF3B3027);

class ShopDetailsScreen extends StatefulWidget {
  const ShopDetailsScreen({super.key, required this.shop});

  final Shop shop;

  @override
  State<ShopDetailsScreen> createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ShopsBloc>().add(GetShopMenu(shop: widget.shop));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              widget.shop.name ?? "",
              style: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
            ),
            Text(
              widget.shop.address ?? "",
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ],
        ),
      ),
      body: BlocBuilder<ShopsBloc, ShopsState>(
        builder: (context, state) {
          if (state is ShopsLoaded && state.items.isNotEmpty) {
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemBuilder: (_, i) {
                return _MenuCard(item: state.items[i]);
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: state.items.length,
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.item});
  final MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFEF3EA),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MenuItemDetailsScreen(item: item),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: beige),
                ),
                child: Icon(Icons.local_cafe_rounded, color: green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: textPrimary,
                      ),
                    ),
                    if ((item.description ?? "").isNotEmpty)
                      Text(
                        item.description ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black54),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${(item.basePriceCents ?? 0)}",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: beige,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'Select',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
