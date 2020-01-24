import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

class ProductOverviewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: AppBar(title: Text('Home'),),
      body: ProductsGrid(),
    );
    return scaffold;
  }
}

