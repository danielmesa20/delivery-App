import 'package:brew_crew/models/Product.dart';
import 'package:brew_crew/screens/products/add_product.dart';
import 'package:brew_crew/screens/products/product_tile.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/CustomAlertDialog.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:flutter/material.dart';

class ListProducts extends StatefulWidget {
  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  //Variables
  List<dynamic> _products;
  final _database = DatabaseService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool delete = false;
  String idProduct, nameProduct;

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  //Get products commerce from API
  getProducts() async {
    //Recived result Api
    dynamic result = await _database.getProducts();

    if (result['err'] == null) {
      setState(() {
        _products =
            result['products'].map((model) => Product.fromJson(model)).toList();
      });
    } else {
      //Show the snackbar with the err
      _scaffoldKey.currentState
          .showSnackBar(showSnackBar(result['err'], Colors.red));
    }
  }

  changeBotton(String id, String name) {
    setState(() {
      idProduct = id;
      nameProduct = name;
      delete = !delete;
    });
  }

  //Delete product
  deleteProduct() async {
    //Recived result Api
    dynamic result = await _database.deleteProduct(idProduct);

    if (result['err'] == null) {
      //Show the snackbar with the err
      _scaffoldKey.currentState.showSnackBar(
          showSnackBar('Delete product completed', Colors.green[500]));
    } else {
      //Show the snackbar with the err
      _scaffoldKey.currentState
          .showSnackBar(showSnackBar(result['err'], Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(2, 128, 144, 1),
      body: SafeArea(
        child: Center(
          child: _products == null
              ? CircularProgressIndicator()
              : _products.length > 0
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Available",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                                SizedBox(width: 5.0),
                                CircleAvatar(
                                  backgroundColor: Colors.green,
                                  radius: 10.0,
                                ),
                                SizedBox(width: 20.0),
                                Text(
                                  "Not Available",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18.0),
                                ),
                                SizedBox(width: 5.0),
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 10.0,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _products.length,
                              itemBuilder: (context, index) {
                                return ProductTile(
                                  product: _products[index],
                                  scaffoldKey: _scaffoldKey,
                                  deleteAction: changeBotton,
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  : Text("There are no products.",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      )),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            delete ? Colors.redAccent : Color.fromRGBO(240, 243, 189, 10),
        child: Icon(
          delete ? Icons.delete : Icons.add,
          color: delete ? Colors.white : Colors.black,
        ),
        onPressed: () async {
          if (delete == false) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddProduct(),
              ),
            );
            if (result != null) {
              _scaffoldKey.currentState
                  .showSnackBar(showSnackBar(result, Colors.green[500]));
            }
          } else {
            final result = await showDialog<int>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return CustomAlertDialog(
                    text:
                        'Are you sure you want to delete the product: $nameProduct');
              },
            );
            if (result == 0) {
              setState(() {
                idProduct = null;
                nameProduct = null;
                delete = false;
              });
            } else {
              deleteProduct();
            }
          }
        },
      ),
    );
  }
}
