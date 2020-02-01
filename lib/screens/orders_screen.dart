import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
class OrdersScreen extends StatelessWidget {

  static const routeName = '/order-screen';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders'),),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx, i){
          return OrderItem(ordersData.orders[i]);
        },
      ),
      drawer: AppDrawer(),
    );
  }
}