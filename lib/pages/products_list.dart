import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gsales_test/product.dart';
import 'package:gsales_test/services/gsales_data.dart';
import 'package:gsales_test/utils/conversion.dart';
import 'package:gsales_test/widgets/product_card.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:gsales_test/order.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProductsList extends StatefulWidget {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  List<Product> products = [
    /*Product("Banana", 20.0),
    Product("Maçã", 20.0),
    Product("Tomate", 5.0),
    Product("Laranja", 9.0),
    Product("Melancia", 10.5),
    Product("Pepino", 1.80)*/
  ];
  Order order =
      Order(products: List<Product>.empty(growable: true), totalValue: 0.0);
  PanelController panelController = PanelController();
  TextEditingController dialogTextEditingControler = TextEditingController();
  bool isLoading = true;

  void getData() async {
    GreenSalesData gsalesData = GreenSalesData();
    await gsalesData.loadSession();
    List<Product> fetchedList = await gsalesData.getAvailableProducts();

    setState(() {
      if (fetchedList.isNotEmpty) products = fetchedList;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void addProductToOrder(Product product) {
    setState(() {
      order.products.add(product);
      order.totalValue += product.price * product.quant;
    });
  }

  void removeProductFromOrder(Product product) {
    setState(() {
      order.totalValue -= product.quant * product.price;
      order.products.remove(product);
    });
  }

  Future<bool> sendOrder(Order order) async {
    GreenSalesData greenSalesData = GreenSalesData();
    await greenSalesData.loadSession();
    bool status = await greenSalesData.postOrder(order);
    return status;
  }

  void showSendOrderSuccessDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return OrderStatusAlertDialog(
            title: "Aviso",
            message: "Pedido enviado!",
            action: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        });
  }

  void showSendOrderFailedDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return OrderStatusAlertDialog(
            title: "Erro",
            message: "Ocorreu um erro. Pedido não enviado, tente novamente.",
            action: () {
              Navigator.pop(context);
            },
          );
        });
  }

  void showProductQuantityDialog(Product product, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          dialogTextEditingControler = TextEditingController();
          return QuantityPromptDialog(
              controller: dialogTextEditingControler,
              price: product.price,
              name: product.name,
              onTapOk: () {
                setState(() {
                  product.quant = int.parse(dialogTextEditingControler.text);
                  addProductToOrder(product);
                });
              });
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
            : SlidingUpPanel(
                panel: Column(children: [
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: CircleAvatar(
                        child: Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.greenAccent[400],
                      )),
                  order.products.isEmpty
                      ? Expanded(
                          child: Center(
                              child: Text(
                                  "O carrinho está vazio, os itens selecionados aparecerão aqui.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 15.0))))
                      : Expanded(
                          child: ListView.builder(
                          padding: EdgeInsets.only(top: 5.0),
                          itemCount: order.products.length,
                          itemBuilder: (context, index) {
                            return ProductCard(
                                product: order.products[index],
                                onTap: () {
                                  removeProductFromOrder(order.products[index]);
                                });
                          },
                        )),
                  if (order.products.isNotEmpty)
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total: ${formatCurrencyReal(order.totalValue)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            TextButton(
                                onPressed: () async {
                                  bool status = await sendOrder(order);
                                  status
                                      ? showSendOrderSuccessDialog(context)
                                      : showSendOrderFailedDialog(context);
                                  panelController.close();
                                },
                                child: Text("Enviar pedido",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0)))
                          ],
                        ))
                ]),
                maxHeight: 500.0,
                minHeight: 50.0,
                controller: panelController,
                backdropEnabled: true,
                backdropTapClosesPanel: true,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                defaultPanelState: PanelState.CLOSED,
                body: ListView.builder(
                  padding: EdgeInsets.only(bottom: 150.0),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return ProductCardOnDisplay(
                        product: products[index],
                        onTap: () {
                          showProductQuantityDialog(products[index], context);
                        });
                  },
                ),
              ));
  }
}

class OrderStatusAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final Function action;

  OrderStatusAlertDialog({this.title, this.message, this.action});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [TextButton(onPressed: action, child: Text("Ok"))],
    );
  }
}

class QuantityPromptDialog extends StatefulWidget {
  final TextEditingController controller;
  final Function onTapOk;
  final double price;
  final String name;

  QuantityPromptDialog({this.controller, this.onTapOk, this.price, this.name});

  @override
  _QuantityPromptDialogState createState() => _QuantityPromptDialogState();
}

class _QuantityPromptDialogState extends State<QuantityPromptDialog> {
  TextEditingController controller;
  int quantity = 0;

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {
        quantity = widget.controller.text.isNotEmpty
            ? int.parse(widget.controller.text)
            : 0;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(widget.name),
        actions: [
          TextButton(
              onPressed: () {
                widget.controller.clear();
                Navigator.pop(context);
              },
              child: Text("Cancelar")),
          TextButton(
              onPressed: () {
                widget.onTapOk();
                widget.controller.clear();
                Navigator.pop(context);
              },
              child: Text("Salvar"))
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
            ),
            Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(widget.controller.text.isNotEmpty
                    ? formatCurrencyReal(widget.price * quantity)
                    : "")),
          ],
        ));
  }
}

/*
class ProductCard extends StatelessWidget {
  final Product product;
  final Function buttonAction;

  ProductCard({this.product, this.buttonAction});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.fromLTRB(5.0, 4.0, 5.0, 4.0),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.name,
                style: TextStyle(fontSize: 18.0, color: Colors.grey[600]),
              ),
              Container(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "R\$ ${product.price}",
                    style: TextStyle(fontSize: 14.0, color: Colors.green),
                  ),
                  IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: buttonAction,
                    color: Colors.green,
                    iconSize: 20.0,
                  )
                ],
              ))
            ],
          ),
        ));
  }
}
*/
