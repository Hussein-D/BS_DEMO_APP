enum OrdersEndpoints {
  getUserOrders,
  placeOrder;

  String getStringPresentation({String? userId}) {
    switch (this) {
      case getUserOrders:
        return "/users/$userId/orders";
      case placeOrder:
        return "/orders";
    }
  }
}
