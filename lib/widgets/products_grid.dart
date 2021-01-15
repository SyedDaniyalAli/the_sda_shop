import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context, listen: true).items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: productsData.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        // create: (ctx) => productsData[index],
        value: productsData[index],
        child: ProductItem(
            // id: productsData[index].id,
            // title: productsData[index].title,
            // imageUrl: productsData[index].imageUrl,
            ),
      ),
    );
  }
}
