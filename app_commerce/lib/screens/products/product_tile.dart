import 'package:brew_crew/models/Product.dart';
import 'package:brew_crew/screens/products/update_product.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatefulWidget {
  //Product object
  final Product product;
  final GlobalKey<ScaffoldState> scaffoldKey;
  //Constructor
  ProductTile({this.product, this.scaffoldKey});

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  Color cardColor = Color.fromRGBO(240, 243, 189, 10);
  Color textColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    //Circle avatar color
    Color cicleColor = widget.product.available ? Colors.green : Colors.red;
    return Card(
      color: cardColor,
      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30.0,
          backgroundColor: cicleColor,
          child: CachedNetworkImage(
            imageUrl: widget.product.imageURL,
            placeholder: (context, url) => CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
            imageBuilder: (context, image) => CircleAvatar(
              backgroundImage: image,
              radius: 25,
            ),
          ),
        ),
        title: Text(
          "Name: ${widget.product.name}",
          style: TextStyle(color: textColor),
        ),
        subtitle: Text(
          'Price: ${widget.product.price}',
          style: TextStyle(color: textColor),
        ),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UpdateProduct(product: widget.product),
            ),
          );
          if (result != null) {
            //Show the snackbar with the message
            widget.scaffoldKey.currentState
                .showSnackBar(showSnackBar(result, Colors.greenAccent));
          }
        },
      ),
    );
  }
}
