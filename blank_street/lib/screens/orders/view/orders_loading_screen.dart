import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OrdersLoadingScreen extends StatelessWidget {
  const OrdersLoadingScreen({super.key, this.itemCount = 6});

  final int itemCount;

  static const cream = Color(0xFFFCF7F2);
  static const beige = Color(0xFFECDBCB);
  static const cardTint = Color(0xFFFEF3EA);

  @override
  Widget build(BuildContext context) {
    final base = beige.withOpacity(.45);
    final highlight = Colors.white.withOpacity(.85);

    return Container(
      color: cream,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: itemCount + 1, // header skeleton + cards
        itemBuilder: (context, i) {
          if (i == 0) {
            return _HeaderShimmer(base: base, highlight: highlight);
          }
          return _OrderCardShimmer(base: base, highlight: highlight);
        },
      ),
    );
  }
}

class _HeaderShimmer extends StatelessWidget {
  const _HeaderShimmer({required this.base, required this.highlight});
  final Color base, highlight;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 140,
              height: 20,
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const Spacer(),
            Container(
              width: 64,
              height: 28,
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCardShimmer extends StatelessWidget {
  const _OrderCardShimmer({required this.base, required this.highlight});
  final Color base, highlight;

  static const cardTint = Color(0xFFFEF3EA);
  static const stroke = Color(0xFFECDBCB);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cardTint,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: stroke),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bar(width: 160, height: 14, r: 6, color: base),
                  const SizedBox(height: 8),
                  _bar(width: 120, height: 12, r: 6, color: base),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _bar(width: 60, height: 16, r: 6, color: base),
                const SizedBox(height: 18),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar({
    required double width,
    required double height,
    required double r,
    required Color color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(r),
      ),
    );
  }
}
