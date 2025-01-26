import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final oldStatus = isFavorite;
    try {
      isFavorite = !isFavorite;
      notifyListeners();
      final url =
          'https://theshopappbysda-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken';
      final response =
          await http.put(Uri.parse(url), body: json.encode(isFavorite));

      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (exceptionMessage) {
      _setFavValue(oldStatus);
    }
  }

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
