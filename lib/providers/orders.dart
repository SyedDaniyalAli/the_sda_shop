import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url =
        'https://theshopappbysda-default-rtdb.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    try {
      //do it
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'product': cartProducts
              .map((product) => {
                    'productId': product.productId,
                    'price': product.price,
                    'title': product.title,
                    'quantity': product.quantity,
                  })
              .toList(),
          'dateTime': timestamp.toIso8601String(),
        }),
      );

      //then do that
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          product: cartProducts,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    } catch (exceptionMessage) {
      print(exceptionMessage);
      throw exceptionMessage;
    }
  }

  void removeOrder(String id) {
    _orders.remove(id);
    notifyListeners();
  }

  int countOrders() {
    return _orders.length;
  }

  void clearPreviousOrders() {
    _orders.clear();
    notifyListeners();
  }
}
