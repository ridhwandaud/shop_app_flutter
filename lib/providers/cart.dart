import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({ 
    @required this.id, 
    @required this.title, 
    @required this.quantity, 
    @required this.price 
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {...items}; 
  }

  void addItem(String productId, double price, String title){
    print('addItem');
    if(_items.containsKey(productId)){
      //change quantity
      _items.update(productId, (exisitingCartItem) => CartItem(id: exisitingCartItem.id, title: exisitingCartItem.title, quantity: exisitingCartItem.quantity + 1, price: exisitingCartItem. price ));
    } else {
      _items.putIfAbsent(productId, () => CartItem(
          id: DateTime.now().toString(), 
          title: title,
          quantity: 1, 
          price: price
        )
      );
    }
    notifyListeners();
  }

  int get itemCount{
    return _items == null ? 0 : _items.length;
  }
}