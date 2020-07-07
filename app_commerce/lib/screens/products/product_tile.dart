import 'package:brew_crew/models/Product.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  
  //variable
  final Product product;
  //Constructor
  ProductTile({this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("hola"),
    );
  }
}