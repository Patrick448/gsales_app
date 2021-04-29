import 'package:gsales_test/product.dart';

class Order {
  List<Product> products;
  String user;
  double totalValue;
  int dateMillisseconds;
  int orderId;

  Order(
      {this.orderId,
      this.user,
      this.products,
      this.totalValue,
      this.dateMillisseconds});
}
