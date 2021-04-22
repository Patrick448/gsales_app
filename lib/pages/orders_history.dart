import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gsales_test/order.dart';
import 'package:gsales_test/services/gsales_data.dart';
import 'package:gsales_test/utils/conversion.dart';
import 'package:gsales_test/widgets/order_card.dart';

class OrdersHistory extends StatefulWidget {
  @override
  _OrdersHistoryState createState() => _OrdersHistoryState();
}

class _OrdersHistoryState extends State<OrdersHistory> {
  List<Order> orders = [];
  bool isLoading = true;

  DateTime initialFilterDate = DateTime(2000);
  DateTime finalFilterDate = DateTime(2001);

  void getData() async {
    GreenSalesData greenSalesData = GreenSalesData();
    await greenSalesData.loadSession();

    List<Order> refreshedOrders = await greenSalesData.getOrders();
    //refreshedOrders = List.from(refreshedOrders.reversed);
    setState(() {
      orders = refreshedOrders;
      isLoading = false;
    });
  }

  void initFilterDates() {
    DateTime currentTime = DateTime.now();
    int year = currentTime.year;
    int month = currentTime.month;
    int day = currentTime.day;

    setState(() {
      initialFilterDate = DateTime(year, month, day);
      finalFilterDate = DateTime(year, month, day);
    });
  }

  Future<DateTime> askDate() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        lastDate: DateTime.now(),
        firstDate: DateTime(1980));

    return date;
  }

  @override
  void initState() {
    super.initState();
    initFilterDates();
    getData();
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
            : Column(
                children: [
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Filtrar de "),
                      TextButton(
                        child: Text(formatDate(initialFilterDate)),
                        onPressed: () async {
                          DateTime dateFromUser = await askDate();
                          if (dateFromUser != null)
                            setState(() {
                              initialFilterDate = dateFromUser;
                            });
                        },
                      ),
                      Text("até"),
                      TextButton(
                        child: Text(formatDate(finalFilterDate)),
                        onPressed: () async {
                          DateTime dateFromUser = await askDate();
                          if (dateFromUser != null)
                            setState(() {
                              finalFilterDate = dateFromUser;
                            });
                        },
                      ),
                      TextButton(
                          onPressed: () async {
                            GreenSalesData greenSalesData = GreenSalesData();
                            await greenSalesData.loadSession();
                            List<Order> filteredOrderList =
                                await greenSalesData.getOrdersFiltered(
                                    initialFilterDate,
                                    finalFilterDate
                                        .add(Duration(seconds: 86399)));

                            setState(() {
                              orders = filteredOrderList;
                            });
                          },
                          child: Text("Ok"))
                    ],
                  )),
                  Expanded(
                      child: ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            return OrderCard(order: orders[index]);
                          }))
                ],
              ));
  }
}
