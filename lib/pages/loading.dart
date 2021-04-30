import 'package:flutter/material.dart';
import 'dart:async';
import 'package:gsales_test/services/gsales_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

void checkLoggedInAndRoute(BuildContext context) async {
  GreenSalesData greenSalesData = GreenSalesData();
  final prefs = await SharedPreferences.getInstance();
  //this line erases the session token, so that the user has to log in everytime
  //kept for testing reasons
  prefs.remove("session-cookie");
  await greenSalesData.loadSession();

  Future.delayed(Duration(seconds: 2), () async {
    bool isLoggedIn = await greenSalesData.isLoggedIn();
    if (isLoggedIn) {
      Navigator.popAndPushNamed(context, '/home');
    } else {
      Navigator.popAndPushNamed(context, '/login');
    }
  });
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    checkLoggedInAndRoute(context);

    return Scaffold(
      backgroundColor: Colors.greenAccent[400],
      body: Center(
        child: Text(
          "GreenSales",
          style: TextStyle(
              color: Colors.white, fontSize: 40.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
