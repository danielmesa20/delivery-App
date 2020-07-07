import 'package:brew_crew/models/Product.dart';
import 'package:brew_crew/screens/products/product_tile.dart';
import 'package:brew_crew/shared/Loading.dart';
import 'package:flutter/material.dart';

class ListProducts extends StatefulWidget {
  ListProducts({Key key}) : super(key: key);

  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {

  List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text("All your products"),
        backgroundColor: Colors.blue[700],
        elevation: 0.0,
        centerTitle: true,
      ),
      body: products == null
          ? Loading()
          : Center(
              child: products.length > 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Sala Pública"),
                            SizedBox(width: 5.0),
                            CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 10.0,
                            ),
                            SizedBox(width: 20.0),
                            Text("Sala Privada"),
                            SizedBox(width: 5.0),
                            CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 10.0,
                            )
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Expanded(
                          child: ListView.builder(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return ProductTile(product: products[index]);
                            },
                          ),
                        )
                      ],
                    )
                  : Text("No hay salas creadas aún",
                      style: TextStyle(fontSize: 20.0)),
            ),
    );
  }
}
