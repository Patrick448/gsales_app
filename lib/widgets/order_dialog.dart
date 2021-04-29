import 'package:flutter/material.dart';
import 'package:gsales_test/order.dart';
import 'package:gsales_test/product.dart';
import 'package:gsales_test/widgets/product_card.dart';
import 'package:gsales_test/utils/conversion.dart';

class OrderDialog extends StatelessWidget {
  final Order order;
  OrderDialog({this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(vertical: 150.0, horizontal: 20.0),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Pedido ${order.orderId.toString().padLeft(6, "0")}",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              )),
          Divider(
            height: 0.0,
            color: Colors.grey[500],
            thickness: 1.0,
          ),
          Expanded(
            child: Container(
                color: Colors.grey[100],
                child: ListView.builder(
                  padding: EdgeInsets.all(5),
                  itemCount: order.products.length,
                  itemBuilder: (context, index) {
                    Product product = order.products[index];
                    return ProductCard(
                      product: product,
                      onTap: () {},
                    );
                  },
                )),
          ),
          Divider(
            color: Colors.grey[500],
            height: 0.0,
            thickness: 1.0,
          ),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0)),
                  Text(formatCurrencyReal(order.totalValue),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0))
                ],
              ))
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
