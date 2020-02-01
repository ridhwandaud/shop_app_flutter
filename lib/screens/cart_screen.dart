import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';

import '../widgets/cart_item.dart';
import './orders_screen.dart';
class CartScreen extends StatelessWidget {

  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart'),),
      body: Column(children: <Widget>[
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total', style: TextStyle(fontSize: 20),),
                Spacer(),
                Chip(label: Text('\$${cart.totalAmount.toString()}', style: TextStyle(color: Colors.white),), backgroundColor: Theme.of(context).primaryColor,),
                FlatButton(
                  child: Text('Order Now'), 
                  onPressed: (){
                    Provider.of<Orders>(context, listen: false).addOrder(cart.items.values.toList(), cart.totalAmount);
                    cart.clear();
                    // Navigator.of(context).pushNamed(
                    //   OrdersScreen.routeName
                    // );
                  }, 
                  textColor: Theme.of(context).primaryColor,)
              ],
            ),
          ),
        ),
        SizedBox(height: 10,),
        Expanded(
          child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (ctx, i){
              return
              CartItem(
                cart.items.values.toList()[i].id,
                cart.items.keys.toList()[i],
                cart.items.values.toList()[i].title,
                cart.items.values.toList()[i].price,
                cart.items.values.toList()[i].quantity,
              );
            },
          ),
        )
      ],),
    );
  }
}