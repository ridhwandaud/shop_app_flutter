import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  
  static const routeName = '/manage-products';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: (){},)
        ],
      ),
      body: Column(children: <Widget>[
        Text('My products')
      ],),
      drawer: AppDrawer(),
    );
  }
}