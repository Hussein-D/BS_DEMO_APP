import 'package:blank_street/models/cart_item.dart';
import 'package:blank_street/models/menu_item.dart';
import 'package:blank_street/models/option_choice.dart';
import 'package:blank_street/models/option_group.dart';
import 'package:blank_street/screens/cart/bloc/cart_bloc.dart';
import 'package:blank_street/screens/shops/bloc/shops_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class MenuItemDetailsScreen extends StatefulWidget {
  const MenuItemDetailsScreen({super.key, required this.item});
  final MenuItem item;

  @override
  State<MenuItemDetailsScreen> createState() => _MenuItemDetailsScreenState();
}

class _MenuItemDetailsScreenState extends State<MenuItemDetailsScreen> {
  int _qty = 1;
  static const cream = Color(0xFFFCF7F2);
  static const cardTint = Color(0xFFFEF3EA);
  static const beige = Color(0xFFECDBCB);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopsBloc, ShopsState>(
      builder: (context, state) {
        if (state is ShopsLoaded) {
          final MenuItem item = state.items.firstWhere(
            (e) => e == widget.item,
            orElse: () => widget.item,
          );
          double total = ((item.basePriceCents ?? 0) / 100);
          for (final OptionGroup g in (item.optionGroups ?? [])) {
            for (final OptionChoice c in (g.choices ?? [])) {
              if (c.isSelected ?? false) {
                total += (c.priceCents ?? 0) / 100;
              }
            }
          }
          total *= _qty;
          return Scaffold(
            backgroundColor: cream,
            appBar: AppBar(
              backgroundColor: cream,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black87),
              title: Text(
                item.name ?? "",
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      Container(
                        height: 140,
                        decoration: BoxDecoration(
                          color: cardTint,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: beige),
                        ),
                        child: const Center(
                          child: Icon(Icons.local_cafe_rounded, size: 40),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.description ?? "",
                        style: TextStyle(color: Colors.black.withOpacity(.7)),
                      ),
                      const SizedBox(height: 16),

                      for (final OptionGroup g
                          in (item.optionGroups ?? [])) ...[
                        Text(
                          g.name ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final OptionChoice c in (g.choices ?? []))
                              _OptionChip(choice: c, group: g, item: item),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],

                      Row(
                        children: [
                          const Text(
                            'Quantity',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const Spacer(),
                          _QtyStepper(
                            qty: _qty,
                            onDec: () =>
                                setState(() => _qty = _qty > 1 ? _qty - 1 : 1),
                            onInc: () => setState(() => _qty++),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  decoration: BoxDecoration(
                    color: cream,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.06),
                        blurRadius: 12,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(
                        "\$$total",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                        ),
                        onPressed: () async {
                          context.read<CartBloc>().add(
                            AddItemToCart(
                              item: CartItem(item: item, quantity: _qty),
                            ),
                          );
                          await Future.delayed(const Duration(milliseconds: 200));
                          Navigator.pop(context);
                        },
                        child: const Text('Add to cart'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.choice,
    required this.group,
    required this.item,
  });
  final OptionChoice choice;
  final OptionGroup group;
  final MenuItem item;

  static const beige = Color(0xFFECDBCB);
  static const cream = Color(0xFFFCF7F2);
  static const green = Color(0xFF0E8A5C);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: (choice.isSelected ?? false) ? green.withOpacity(.12) : cream,
      shape: StadiumBorder(
        side: BorderSide(color: (choice.isSelected ?? false) ? green : beige),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: () => context.read<ShopsBloc>().add(
          ToggleGroupChoice(group: group, choice: choice, item: item),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            "${choice.name ?? ""} ${(choice.priceCents ?? 0) == 0 ? "" : "+ \$${(choice.priceCents ?? 0) / 100}"}",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: (choice.isSelected ?? false)
                  ? Colors.black
                  : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.qty,
    required this.onDec,
    required this.onInc,
  });
  final int qty;
  final VoidCallback onDec, onInc;
  static const beige = Color(0xFFECDBCB);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: beige),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: onDec, icon: const Icon(Icons.remove)),
          Text('$qty', style: const TextStyle(fontWeight: FontWeight.w700)),
          IconButton(onPressed: onInc, icon: const Icon(Icons.add)),
        ],
      ),
    );
  }
}
