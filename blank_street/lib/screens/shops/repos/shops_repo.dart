import 'package:blank_street/core/type_defs/api_service_output.dart';
import 'package:blank_street/models/menu_item.dart';
import 'package:blank_street/models/shop.dart';
import 'package:blank_street/network/api_service.dart';
import 'package:blank_street/screens/shops/repos/shops_endpoints.dart';

abstract class ShopsRepo {
  ApiServiceOutput<List<Shop>> getShops();
  ApiServiceOutput<List<MenuItem>> getShopMenu({required Shop shop});
}

class ShopsRempoImpl extends ShopsRepo {
  final ApiService apiService;
  ShopsRempoImpl({required this.apiService});
  @override
  ApiServiceOutput<List<Shop>> getShops() async {
    return await apiService.getList(
      endpoint: ShopsEndpoints.getShops.getStringPresentation(),
      fromJson: Shop.fromJson,
    );
  }

  @override
  ApiServiceOutput<List<MenuItem>> getShopMenu({required Shop shop}) async {
    return await apiService.getList(
      endpoint: ShopsEndpoints.getShopMenuItem.getStringPresentation(shop: shop),
      fromJson: MenuItem.fromJson,
    );
  }
}
