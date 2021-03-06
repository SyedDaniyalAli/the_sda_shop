import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as orderClass;

class OrderItem extends StatefulWidget {
  final orderClass.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height:
          _expanded ? min(widget.order.product.length * 20.0 + 110, 200) : 110,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('Rs.${widget.order.amount}'),
              subtitle: Text(DateFormat('dd/MM//YYYY hh:mm')
                  .format(widget.order.dateTime)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
              height: _expanded ? min(widget.order.product.length * 20.0 + 10, 180) : 0 ,
              duration: Duration(milliseconds: 300),
              child: ListView(
                children: widget.order.product
                    .map((currentProduct) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currentProduct.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${currentProduct.quantity}x  Rs. ${currentProduct.price}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
