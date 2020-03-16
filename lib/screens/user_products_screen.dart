import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatefulWidget {
  
  static const routeName = '/manage-products';

  @override
  _UserProductsScreenState createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  var _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Products>(context, listen: false).fetchAndSetProducts(true).then((onValue){
      _isLoading = false;
    });
    super.initState();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    try {
      await Provider.of<Products>(context, listen: false)
          .fetchAndSetProducts(true);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text(error.toString()),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        )
      );
    }
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
      body: 
        RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: _isLoading ? Center(child: CircularProgressIndicator(),) : Padding(
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