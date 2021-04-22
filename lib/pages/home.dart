import 'package:flutter/material.dart';
import 'package:gsales_test/services/gsales_data.dart';

class Home extends StatelessWidget {
  GreenSalesData greenSalesData = GreenSalesData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Green Sales"),
          backgroundColor: Colors.greenAccent[400],
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/products_list');
                },
                icon: Icon(Icons.shopping_cart),
                label: Text("Disponíveis Hoje")),
            TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/order_history');
                },
                icon: Icon(Icons.list),
                label: Text("Meus Pedidos")),
            TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.person),
                label: Text("Minha Conta")),
            TextButton.icon(
                onPressed: () async {
                  greenSalesData.loadSession();
                  greenSalesData.logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: Icon(Icons.logout),
                label: Text("Sair")),
          ],
        ));
  }
}
