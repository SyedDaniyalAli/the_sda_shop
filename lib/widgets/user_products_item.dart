import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../providers/products_provider.dart';
import '../screens/edit_product_screen.dart';

class UserProductsItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductsItem({Key key, this.title, this.imageUrl, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scaffoldContext = ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
              ),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context).deleteProduct(id);
                } catch (exceptionMessage) {
                  _scaffoldContext.showSnackBar(
                      SnackBar(content: Text('Deleting Failed!', textAlign: TextAlign.center,)));
                }

                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text('Do you want to delete this product?'),
                    actions: [
                      FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          Toast.show('Product is Safe', context,
                              duration: 2, gravity: Toast.CENTER);
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Provider.of<Products>(
                            context,
                            listen: false,
                          ).deleteProduct(id);

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Product Deleted Successfully'),
                          ));

                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
