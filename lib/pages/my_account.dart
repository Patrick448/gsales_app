import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gsales_test/pages/loading.dart';
import 'package:gsales_test/services/gsales_data.dart';
import 'package:gsales_test/user.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  User user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    GreenSalesData greenSalesData = GreenSalesData();
    await greenSalesData.loadSession();
    User newUser = await greenSalesData.getUserData();
    setState(() {
      user = newUser;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Green Sales"),
        backgroundColor: Colors.greenAccent[400],
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? Container(
              child: SpinKitRing(color: Colors.greenAccent[400], size: 50.0))
          : Padding(
              padding: EdgeInsets.fromLTRB(25, 25, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[350],
                    radius: 35,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 15, bottom: 15),
                      child: Center(
                          child: Text(
                        "${user.name}",
                        style: TextStyle(fontSize: 18),
                      ))),
                  Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Email: ${user.email}",
                        style: TextStyle(fontSize: 16),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Número: ---------------",
                        style: TextStyle(fontSize: 16),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Endereço: -------------------",
                        style: TextStyle(fontSize: 16),
                      )),
                ],
              )),
    );
  }
}
