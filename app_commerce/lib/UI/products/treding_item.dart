import 'package:brew_crew/UI/products/start_rating.dart';
import 'package:brew_crew/UI/products/update_product.dart';
import 'package:brew_crew/blocs/listProducts/bloc/listproducts_bloc.dart';
import 'package:brew_crew/Models/Product.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrendingItem extends StatelessWidget {
  final Product product;
  final GlobalKey<ScaffoldState> scaffoldKey;

  TrendingItem({this.product, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 2,
        color: Color.fromRGBO(2, 128, 144, 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            _productImage(),
            _productDetails(),
          ],
        ),
      ),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpdateProduct(product: product),
          ),
        );
        if (result != null) {
          //Show the snackbar with the message
          scaffoldKey.currentState
              .showSnackBar(showSnackBar(result, Colors.greenAccent));
          //Reload product list
          BlocProvider.of<ListproductsBloc>(context).add(LoadProducts());
        }
      },
    );
  }

  _productImage() {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            child: CircleAvatar(
              radius: 50.0,
              child: CachedNetworkImage(
                imageUrl: product.imageURL,
                placeholder: (context, url) => CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
                imageBuilder: (context, image) => CircleAvatar(
                  backgroundColor: Color.fromRGBO(2, 89, 111, 126),
                  backgroundImage: image,
                  radius: 50.0,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  _productDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 10),
        Text(
          product.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Text(
          '\$ ${product.price}',
          style: TextStyle(
            color: Colors.greenAccent[400],
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
        StarRating(
          rating: product.rating,
          size: 20,
        ),
      ],
    );
  }
}
