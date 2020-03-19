import 'package:flutter/material.dart';
import 'dart:math';

import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {

  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded? Icons.expand_less :Icons.expand_more), 
              onPressed: (){
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if(_expanded) 
          Container(
            height: min(widget.order.products.length * 20.0 + 50, 180),
            child: ListView(
              children: widget.order.products.map(
                (prod) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(prod.title, style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),),
                      Text('${prod.quantity} x'),
                      Text('\$${prod.price * prod.quantity}')
                    ],
                  ),
                )).toList(),
            ),
          )
        ],
      ),
    );
  }
}