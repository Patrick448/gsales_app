import 'package:flutter/material.dart';
import 'package:gsales_test/services/gsales_data.dart';

class Home extends StatelessWidget {
  final GreenSalesData greenSalesData = GreenSalesData();

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
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0, primary: Colors.greenAccent[400]),
                  onPressed: () {
                    Navigator.pushNamed(context, '/products_list');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart),
                      Expanded(child: Center(child: Text("Comprar")))
                    ],
                  ),
                )),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0, primary: Colors.greenAccent[400]),
                  onPressed: () {
                    Navigator.pushNamed(context, '/order_history');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.list),
                      Expanded(child: Center(child: Text("Meus pedidos")))
                    ],
                  ),
                )),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0, primary: Colors.greenAccent[400]),
                  onPressed: () {
                    Navigator.pushNamed(context, '/my_account');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.person),
                      Expanded(child: Center(child: Text("Minha conta")))
                    ],
                  ),
                )),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0, primary: Colors.greenAccent[400]),
                  onPressed: () async {
                    await greenSalesData.loadSession();
                    bool loggedOut = await greenSalesData.logout();
                    if (loggedOut)
                      Navigator.pushReplacementNamed(context, '/login');
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Erro. Não foi possível sair da conta, tente novamente.")));
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      Expanded(child: Center(child: Text("Sair")))
                    ],
                  ),
                )),
          ],
        ));
  }
}
