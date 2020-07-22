import 'package:brew_crew/Models/Product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Product>>(context);

    print("products $products");
    print("products lenght ${products.length}");

    return Container(
      child: products != null
          ? products.length > 0
              ? Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return Text("products");
                    },
                  ),
                )
              : Text("Lenght = 0")
          : Text("null"),
    );
  }
}
