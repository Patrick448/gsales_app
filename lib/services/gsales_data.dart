import 'package:gsales_test/order.dart';
import 'package:gsales_test/product.dart';
import 'package:gsales_test/user.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class GreenSalesData {
  List<Product> products;
  Map<String, String> requestHeaders = {};

  //urls to the server hosted online and to the one hosted locally
  static String webUrl = "http://patrick448.pythonanywhere.com";
  static String localUrl = "http://192.168.0.173:5000";
  //url currently being used by the app
  String url = localUrl;

  GreenSalesData();

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    requestHeaders = {"cookie": prefs.getString("session-cookie")};
  }

  Future<int> loginUser(String email, String password) async {
    Map<String, String> headers = {};

    Map<String, String> body = {"email": email, "password": password};

    try {
      //posts the login form to the backend
      Response response =
          await post('$url/test-login', headers: headers, body: body);

      //gets the session cookie from the response and stores it in the request headers
      //that will be used for future requests
      String sessionCookie = response.headers["set-cookie"];
      requestHeaders = {"cookie": sessionCookie};

      //stores the session cookie in the shared preferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("session-cookie", sessionCookie);

      print("Login request returned ${response.statusCode}");
      return response.statusCode;
    } catch (e) {
      print("Error logging in: $e");
    }

    return 0;
  }

  Future<bool> logout() async {
    Response response = await get('$url/logout', headers: requestHeaders);
    return response.statusCode == 200;
  }

  Future<bool> isLoggedIn() async {
    try {
      Response response =
          await get('$url/check-logged-in', headers: requestHeaders);
      return jsonDecode(response.body)['logged_in'];
    } catch (e) {
      return false;
    }
  }

  Future<List<Order>> getOrders() async {
    Response response =
        await get('$url/get-all-orders', headers: requestHeaders);

    List<dynamic> ordersData = jsonDecode(response.body);
    List<Order> orders = [];
    print(ordersData);

    for (int i = 0; i < ordersData.length; i++) {
      Map orderData = ordersData[i];
      List<Product> products = [];

      for (int j = 0; j < orderData['items'].length; j++) {
        Map productData = orderData['items'][j];

        Product product = Product(
            productData['name'], double.parse(productData['price'].toString()));
        product.quant = int.parse(productData['quant'].toString());
        products.add(product);
      }

      Order order = Order(
          dateMillisseconds: orderData['timeStamp'],
          user: orderData['user_name'],
          totalValue: orderData['total'],
          orderId: orderData['id'],
          products: products);
      orders.add(order);
    }

    return orders;
  }

  Future<List<Order>> getOrdersFiltered(
      DateTime dateFrom, DateTime dateTo) async {
    Response response = await get(
        '$url/get_orders/by_date/${dateFrom.millisecondsSinceEpoch}+${dateTo.millisecondsSinceEpoch}',
        headers: requestHeaders);

    List<dynamic> ordersData = jsonDecode(response.body);
    List<Order> orders = [];
    print(ordersData);

    for (int i = 0; i < ordersData.length; i++) {
      Map orderData = ordersData[i];
      List<Product> products = [];

      for (int j = 0; j < orderData['items'].length; j++) {
        Map productData = orderData['items'][j];

        Product product = Product(
            productData['name'], double.parse(productData['price'].toString()));
        product.quant = int.parse(productData['quant'].toString());
        products.add(product);
      }

      Order order = Order(
          dateMillisseconds: orderData['timeStamp'],
          user: orderData['user_name'],
          totalValue: orderData['total'],
          orderId: orderData['id'],
          products: products);
      orders.add(order);
    }

    return orders;
  }

  Future<void> getData() async {
    //don't use this function, remove later

    products = [];
    try {
      Response response = await get('$url/pedido/get-list-no-login-test');
      List<dynamic> data = jsonDecode(response.body);
      print(data.toString());

      for (int i = 0; i < data.length; i++) {
        products.add(Product(
            "${data[i]['name']} (${data[i]['unit']})", data[i]['price']));
      }
    } catch (e) {
      print(
          "Could not get data. Green Sales data service caught an error: \n $e");
    }
  }

  Future<bool> postOrder(Order order) async {
    Iterable items = order.products.map((product) {
      return {
        'id': product.id,
        'name': product.name,
        'price': product.price,
        'quant': product.quant
      };
    });

    Map<String, dynamic> orderData = {
      'order': {'total': order.totalValue.toString(), 'items': items.toList()}
    };
    Map<String, String> postHeader = requestHeaders;
    requestHeaders['Content-Type'] = 'application/json';

    try {
      Response response = await post('$url/save-order',
          headers: postHeader, body: jsonEncode(orderData));
      return response.statusCode == 200;
    } catch (e) {
      print("Error. Order not sent.\n $e");
    }

    return false;
  }

  Future<List<Product>> getAvailableProducts() async {
    products = [];
    try {
      Response response =
          await get('$url/pedido/get-list', headers: requestHeaders);
      List<dynamic> data = jsonDecode(response.body);
      print(data.toString());

      for (int i = 0; i < data.length; i++) {
        Product product = Product("${data[i]['name']}", data[i]['price']);
        product.id = data[i]['id'];
        product.unit = data[i]['unit'];
        products.add(product);
      }
    } catch (e) {
      print(
          "Could not get data. Green Sales data service caught an error: \n $e");
    }

    return products;
  }

  Future<User> getUserData() async {
    Response response =
        await get('$url/get-user-data', headers: requestHeaders);
    Map<String, dynamic> data = jsonDecode(response.body);
    User user = User();
    user.name = data['name'];
    user.email = data['email'];
    user.id = data['id'];
    user.level = data['level'];

    return user;
  }
}
