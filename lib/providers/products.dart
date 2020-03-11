import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './product.dart';

class Products with ChangeNotifier{
  List<Product> _items = [];

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    var url = 'https://shop-app-fc74f.firebaseio.com/products.json?auth=$authToken';

     final response = await http.get(url);

      print(json.decode(response.body));
      
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
  
      if(extractedData == null){
        notifyListeners();
        return;
      }

      url = 'https://shop-app-fc74f.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProduct = [];

      extractedData.forEach((prodId,prodData){
        loadedProduct.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: favoriteData ==  null ? false : favoriteData[prodId] ?? false,
            imageUrl: prodData['imageUrl'],
          )
        );
      });

      _items = loadedProduct;
      notifyListeners();
  }

  Future<void> addProduct(Product product){
    final url = 'https://shop-app-fc74f.firebaseio.com/products.json?auth=$authToken';

    return http.post(url, body: json.encode({
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'imageUrl': product.imageUrl
    })).then((response){
      print(response);
      final newProduct = Product(title: product.title, id: json.decode(response.body)['name'], price: product.price, description: product.description, imageUrl: product.imageUrl);
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error){
      throw error;
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async{
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    final url = 'https://shop-app-fc74f.firebaseio.com/products/$id.json?auth=$authToken';

    await http.patch(url, body: json.encode({
      'title': newProduct.title,
      'description': newProduct.description,
      'imageUrl': newProduct.imageUrl,
      'price': newProduct.price
    }));

    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  void deleteProduct(String id){

    final url = 'https://shop-app-fc74f.firebaseio.com/products/$id.json?auth=$authToken';
    http.delete(url);
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  Product findById(String id){
    return _items.firstWhere((prod) => prod.id == id);
  }
} 