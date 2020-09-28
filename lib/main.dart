import 'package:cod3r_shop/providers/cart_provider.dart';
import 'package:cod3r_shop/providers/orders.dart';
import 'package:cod3r_shop/providers/product_provider.dart';
import 'package:cod3r_shop/utils/app_routes.dart';
import 'package:cod3r_shop/views/cart_screen.dart';
import 'package:cod3r_shop/views/orders_screen.dart';
import 'package:cod3r_shop/views/product_detail_screen.dart';
import 'package:cod3r_shop/views/product_form_screen.dart';
import 'package:cod3r_shop/views/products_overview_screen.dart';
import 'package:cod3r_shop/views/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Provider notificador do dart
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        )
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {
          AppRoutes.HOME: (ctx) => ProductOverviewScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrdersScreens(),
          AppRoutes.PRODUCTS: (ctx) => ProductsScreen(),
          AppRoutes.PRODUCT_FORM: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}
