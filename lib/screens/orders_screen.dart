import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {

  static const routeName = '/order-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  var _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((onValue){
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders'),),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx, i){
          return OrderItem(ordersData.orders[i]);
        },
      ),
      drawer: AppDrawer(),
    );
  }
}