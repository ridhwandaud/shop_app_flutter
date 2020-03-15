import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  
  static const routeName = '/manage-products';

  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<Products>(context).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.add), onPressed: (){
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          },)
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: products.items.length,
            itemBuilder: (ctx,i) => Column(
              children: <Widget>[
                UserProductItem(products.items[i].title, products.items[i].imageUrl, products.items[i].id),
                Divider()
              ],
            ),
          )
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}