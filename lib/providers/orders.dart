import 'package:flutter/foundation.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> product;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.product,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        product: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void removeOrder(String id) {
    _orders.remove(id);
    notifyListeners();
  }

  int countOrders() {
    return _orders.length;
  }

  void clearPreviousOrders()
  {
    _orders.clear();
    notifyListeners();
  }
}
