import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
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
    this.imageUrl, 
    this.isFavorite = false
  });

  void toggleFavoriteStatus(String token, String userId){
    isFavorite = !isFavorite;
    final url = 'https://shop-app-fc74f.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    http.put(url, body: json.encode(
      isFavorite
    ));

    notifyListeners();
  }
}