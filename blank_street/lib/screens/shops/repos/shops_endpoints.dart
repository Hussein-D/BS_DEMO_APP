import 'package:blank_street/models/shop.dart';

enum ShopsEndpoints {
  getShops,
  getShopMenuItem;

  String getStringPresentation({Shop? shop}) {
    switch (this) {
      case getShops:
        return "/shops";
      case getShopMenuItem:
        return "/shops/${shop?.id}/menu";
    }
  }
}
