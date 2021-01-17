import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final String title;
  final int quantity;

  const CartItem({Key key, this.id, this.price, this.title, this.quantity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
          leading: CircleAvatar(
            child: Text('Rs.$price'),
          ),
          title: Text(title),
          subtitle: Text('Total: Rs.${(quantity * price)}'),
          trailing: Text('$quantity x'),
        ),
      ),
    );
  }
}
