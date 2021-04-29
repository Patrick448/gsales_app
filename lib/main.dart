import 'package:flutter/material.dart';
import 'package:gsales_test/pages/orders_history.dart';
import 'pages/products_list.dart';
import 'pages/loading.dart';
import 'pages/home.dart';
import 'pages/login.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => Loading(),
      '/login': (context) => Login(),
      '/home': (context) => Home(),
      '/products_list': (context) => ProductsList(),
      '/order_history': (context) => OrdersHistory()
    },
  ));
}
