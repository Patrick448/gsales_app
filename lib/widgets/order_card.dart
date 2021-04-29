import 'package:flutter/material.dart';
import 'package:gsales_test/order.dart';
import 'package:gsales_test/utils/conversion.dart';
import 'package:gsales_test/widgets/order_dialog.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  DateTime dateTime;

  OrderCard({this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            borderRadius: BorderRadius.circular(3),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return OrderDialog(order: order);
                  });
            },
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${order.orderId}".padLeft(6, "0"),
                          style: TextStyle(
                              fontSize: 17.0,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.normal)),
                      Text(formatDateFromMillisseconds(order.dateMillisseconds),
                          style: TextStyle(
                              fontSize: 15.0, color: Colors.grey[700]))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(formatCurrencyReal(order.totalValue),
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.green[500],
                              fontWeight: FontWeight.bold)),
                      Text("${order.products.length} itens",
                          style: TextStyle(
                              fontSize: 15.0, color: Colors.grey[700]))
                    ],
                  )
                ],
              ),
            )));
  }
}
