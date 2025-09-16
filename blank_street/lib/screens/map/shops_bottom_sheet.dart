import 'package:blank_street/models/shop.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShopsBottomSheet extends StatefulWidget {
  const ShopsBottomSheet({
    super.key,
    required this.shops,
    required this.currentLocation,
    required this.placemarks,
  });
  final List<Shop> shops;
  final LatLng currentLocation;
  final Map<String, List<Placemark>> placemarks;
  @override
  State<ShopsBottomSheet> createState() => _ShopsBottomSheetState();
}

class _ShopsBottomSheetState extends State<ShopsBottomSheet> {
  bool _isSearching = false;
  final TextEditingController _controller = TextEditingController();
  List<Shop> _filtered() {
    return widget.shops
        .where(
          (e) => (e.name ?? "").toLowerCase().contains(
            _controller.text.trim().toLowerCase(),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(20),
          child: FilledButton(onPressed: () {}, child: Text("VIEW MORE")),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, anim) {
                      return FadeTransition(
                        opacity: anim,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.05, 0),
                            end: Offset.zero,
                          ).animate(anim),
                          child: child,
                        ),
                      );
                    },
                    child: _isSearching
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: TextField(
                              controller: _controller,
                              onChanged: (value) => setState(() {}),
                              decoration: InputDecoration(
                                hintText: "Search shops...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          )
                        : TabBar(
                            padding: EdgeInsets.zero,
                            dividerColor: Colors.transparent,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            tabs: [
                              Tab(text: "Nearby"),
                              Tab(text: "Previous"),
                            ],
                          ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, anim) {
                    return FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    );
                  },
                  child: _isSearching
                      ? GestureDetector(
                          onTap: () => setState(() {
                            _isSearching = false;
                            _controller.clear();
                          }),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF5F5DC),
                            ),
                            child: Icon(Icons.close_rounded),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => setState(() {
                            _isSearching = true;
                          }),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFF5F5DC),
                            ),
                            child: Icon(Icons.search_rounded),
                          ),
                        ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "${_filtered().length} results nearby",
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _filtered().length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xFFF5F5DC), width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    leading: Container(
                      width: 70,
                      height: 100,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(
                        "https://i.pravatar.cc/128?u=${_filtered()[index].id}",
                        width: 70,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image_rounded),
                      ),
                    ),
                    title: Text(_filtered()[index].name ?? ""),
                    subtitle: Text(
                      "${(Geolocator.distanceBetween(widget.currentLocation.latitude, widget.currentLocation.longitude, _filtered()[index].lat ?? 0.0, _filtered()[index].lon ?? 0.0) / 1000).toStringAsFixed(2)} km\n"
                      "${(widget.placemarks[_filtered()[index].id] as List<Placemark>).first.name}",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: SizedBox(
                      height: 30,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: Color(0xFFF5F5DC),
                        ),
                        onPressed: () {},
                        child: Text(
                          "SELECT",
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
