import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './product.dart';

class Products with ChangeNotifier{
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts(){
    const url = 'https://shop-app-fc74f.firebaseio.com/products.json';

    return http.get(url)
    .then((response){

      print(json.decode(response.body));
      
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
  
      if(extractedData == null){
        notifyListeners();
        return;
      }

      final List<Product> loadedProduct = [];

      extractedData.forEach((prodId,prodData){
        loadedProduct.add(
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            isFavorite: prodData['isFavorite'],
            imageUrl: prodData['imageUrl'],
          )
        );
      });

      _items = loadedProduct;
      notifyListeners();
    });
  }

  Future<void> addProduct(Product product){
    const url = 'https://shop-app-fc74f.firebaseio.com/products.json';

    return http.post(url, body: json.encode({
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'imageUrl': product.imageUrl,
      'isFavorite': product.isFavorite
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

    final url = 'https://shop-app-fc74f.firebaseio.com/products/$id.json';

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

    final url = 'https://shop-app-fc74f.firebaseio.com/products/$id.json';
    http.delete(url);
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  Product findById(String id){
    return _items.firstWhere((prod) => prod.id == id);
  }
} 