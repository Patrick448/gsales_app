import 'package:flutter/material.dart';
import 'package:gsales_test/services/gsales_data.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Green Sales"),
        backgroundColor: Colors.greenAccent[400],
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
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
                    "Ana Maria",
                    style: TextStyle(fontSize: 18),
                  ))),
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Email: ana@gmail.com",
                    style: TextStyle(fontSize: 16),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Número: (21) 9 0102-3658",
                    style: TextStyle(fontSize: 16),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    "Endereço: Avenida José da Silva",
                    style: TextStyle(fontSize: 16),
                  )),
            ],
          )),
    );
  }
}
