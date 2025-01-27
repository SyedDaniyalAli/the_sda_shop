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
      {required this.id,
      required this.amount,
      required this.product,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://theshopappbysda-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          product: (orderData['products'] as List<dynamic>)
              .map(
                (currentItem) => CartItem(
                    id: currentItem['id'],
                    productId: currentItem['id'],
                    title: currentItem['title'],
                    quantity: currentItem['quantity'],
                    price: currentItem['price']),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://theshopappbysda-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    try {
      //do it
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'amount': total,
          'products': cartProducts
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
