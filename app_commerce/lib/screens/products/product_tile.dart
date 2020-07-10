import 'package:brew_crew/models/Product.dart';
import 'package:brew_crew/screens/products/update_product.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatefulWidget {
  //Product object
  final Product product;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function deleteAction;
  //Constructor
  ProductTile({this.product, this.scaffoldKey, this.deleteAction});

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    //Circle avatar
    Color cicleColor = widget.product.available ? Colors.green : Colors.red;
    Color cardColor = Color.fromRGBO(240, 243, 189, 10);

    return Card(
      color: cardColor,
      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
      child: ListTile(
          leading: CircleAvatar(
            radius: 30.0,
            backgroundColor: cicleColor,
            child: CircleAvatar(
              radius: 25.0,
              backgroundColor: Color.fromRGBO(2, 128, 144, 10),
              backgroundImage: NetworkImage(widget.product.imageURL),
            ),
          ),
          title: Text("Name: ${widget.product.name}"),
          subtitle: Text('Price: ${widget.product.price}'),
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateProduct(product: widget.product),
              ),
            );
            if (result != null) {
              //Show the snackbar with the err
              widget.scaffoldKey.currentState
                  .showSnackBar(showSnackBar(result, Colors.greenAccent));
            }
          },
          onLongPress: () {
            setState(() {
              cardColor = Colors.greenAccent[700];
            });
            widget.deleteAction(widget.product.id, widget.product.name);
          }),
    );
  }
}
