import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gsales_test/error_explainer.dart';
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

  void getData() async {
    GreenSalesData greenSalesData = GreenSalesData();
    await greenSalesData.loadSession();

    ResponseData<List<Order>> ordersData = await greenSalesData.getOrders();
    //refreshedOrders = List.from(refreshedOrders.reversed);

    if (ordersData.status == 200) {
      setState(() {
        orders = ordersData.data;
        isLoading = false;
      });
    } else {
      ErrorExplainer().showErrorSnackbar(
          code: ordersData.status,
          callback: () {
            getData();
          },
          context: context);
    }
  }

  Future<void> getFilteredOrders(DateTime timeFrom, DateTime timeTo) async {
    GreenSalesData greenSalesData = GreenSalesData();
    await greenSalesData.loadSession();
    ResponseData<List<Order>> filteredOrdersData = await greenSalesData
        .getOrdersFiltered(timeFrom, timeTo.add(Duration(seconds: 86399)));

    if (filteredOrdersData.status == 200)
      setState(() {
        orders = filteredOrdersData.data;
      });
    else
      ErrorExplainer().showErrorSnackbar(
          code: filteredOrdersData.status,
          callback: () {
            getFilteredOrders(timeFrom, timeTo);
          },
          context: context);
  }

  @override
  void initState() {
    super.initState();
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
                  OrderFilters(
                    callback: getFilteredOrders,
                    refreshAction: () {
                      getData();
                    },
                  ),
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

class OrderFilters extends StatefulWidget {
  //final DateTime initialFilterDate;
  //final DateTime finalFilterDate;
  final Function callback;
  final Function refreshAction;

  OrderFilters({this.callback, this.refreshAction});

  @override
  _OrderFiltersState createState() => _OrderFiltersState();
}

class _OrderFiltersState extends State<OrderFilters> {
  bool filtersOpen = false;
  DateTime initialFilterDate;
  DateTime finalFilterDate;

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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: filtersOpen
            ? Column(children: [
                Row(
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
                        onPressed: () {
                          widget.callback(initialFilterDate, finalFilterDate);
                        },
                        child: Text("Ok"))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          widget.refreshAction();
                        },
                        icon: Icon(Icons.refresh, color: Colors.grey[600])),
                  ],
                ),
                TextButton.icon(
                    onPressed: () {
                      setState(() {
                        filtersOpen = false;
                      });
                    },
                    label: Text("Fechar"),
                    icon: Icon(Icons.arrow_drop_up))
              ])
            : TextButton.icon(
                onPressed: () {
                  setState(() {
                    filtersOpen = true;
                  });
                },
                icon: Icon(
                  Icons.arrow_drop_down,
                ),
                label: Text("Filtros")));
  }
}
