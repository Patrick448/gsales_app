import 'package:flutter/material.dart';
import 'package:gsales_test/product.dart';
import 'package:gsales_test/utils/conversion.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function onTap;

  ProductCard({this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: onTap,
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${product.name}",
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Text("x${product.quant}",
                            style: TextStyle(color: Colors.grey[600]))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(formatCurrencyReal(product.price)),
                        Text(
                          formatCurrencyReal(product.price * product.quant),
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ))));
  }
}

class ProductCardOnDisplay extends StatelessWidget {
  final Product product;
  final Function onTap;

  ProductCardOnDisplay({this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: onTap,
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${product.name}",
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Text(product.unit,
                            style: TextStyle(color: Colors.grey[600]))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          formatCurrencyReal(product.price),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    )
                  ],
                ))));
  }
}
