import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import '../models/http_exception.dart';
import '../constants.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String authToken, String userId) async {
    final oldStatus = isFavorite;
    setFavValue(!isFavorite);
    final url = FIREBASE_URL_ENDPOINT + '/userFavorites/$userId/$id.json?auth=$authToken';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );

      if (response.statusCode >= 400) {
        setFavValue(oldStatus);
        throw HttpException('Could not favorite product.');
      }
    } catch (error) {
      setFavValue(oldStatus);
    }
  }
}
