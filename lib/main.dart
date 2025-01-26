import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './helpers/custom_route.dart';
import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products_provider.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/user_products_screen.dart';
import 'screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //it's efficient than value parameter and come after 4 version of provider
        ChangeNotifierProvider(create: (ctx) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(
            ctx.read<Auth>().token,
            [],
            ctx.read<Auth>().userId,
          ),
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            previousProducts == null ? [] : previousProducts.items,
            auth.userId,
          ),
        ),
        ChangeNotifierProvider(create: (ctx) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
          create: (ctx) => Orders(
            ctx.read<Auth>().token,
            ctx.read<Auth>().userId,
            [],
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
              fontFamily: 'Lato',
              // Custom Route Transitions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionsBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionsBuilder(),
                },
              ),
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                  .copyWith(secondary: Colors.deepOrange)),
          // home: ProductsOverviewScreen(),
          routes: {
            '/': (ctx) => auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
            // ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
          },
        ),
      ),
    );
  }
}
