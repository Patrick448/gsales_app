class Product {
  String name;
  double price;
  int id;
  int quant = 0;
  String unit = "";

  Product(String name, double price) {
    this.name = name;
    this.price = price;
  }

  String getName() {
    return name;
  }

  double getPrice() {
    return price;
  }
}
