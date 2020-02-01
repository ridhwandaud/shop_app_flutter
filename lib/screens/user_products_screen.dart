import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
class UserProductsScreen extends StatelessWidget {
  
  static const routeName = '/manage-products';
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: (){},)
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: products.items.length,
          itemBuilder: (ctx,i) => Column(
            children: <Widget>[
              UserProductItem(products.items[i].title, products.items[i].imageUrl),
              Divider()
            ],
          ),
        )
      ),
      drawer: AppDrawer(),
    );
  }
}