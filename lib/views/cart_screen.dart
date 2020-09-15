import 'package:cod3r_shop/providers/cart_provider.dart';
import 'package:cod3r_shop/providers/orders.dart';
import 'package:cod3r_shop/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartProvider cart = Provider.of(context);
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(25),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 10),
                  Chip(
                    label: Text(
                      'R\$${cart.totalAmount}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  FlatButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false)
                          .addOrder(cartItems, cart.totalAmount);
                      cart.clear();
                    },
                    child: Text(
                      'COMPRAR',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemsCount,
              itemBuilder: (ctx, i) => CartItemWidget(
                cartItem: cartItems[i],
              ),
            ),
          )
        ],
      ),
    );
  }
}
