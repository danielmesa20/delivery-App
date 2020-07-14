import 'package:brew_crew/models/Product.dart';
import 'package:brew_crew/screens/products/add_product.dart';
import 'package:brew_crew/screens/products/product_tile.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/CustomAlertDialog.dart';
import 'package:brew_crew/shared/CustomButton.dart';
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

  //Load products
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

      //setState(() => _products = []);
      
      //Show the snackbar with the err
      _scaffoldKey.currentState
          .showSnackBar(showSnackBar(result['err'], Colors.red));

          
    }
  }

  //Delete product
  deleteProduct(String id) async {
    //Show Dialog
    onLoading(context);

    //Recived result Api
    dynamic result = await _database.deleteProduct(id);

    //Pop Dialog
    Navigator.pop(context);

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
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20.0),
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
                                return Dismissible(
                                  key: ValueKey(_products[index]),
                                  child: ProductTile(
                                    product: _products[index],
                                    scaffoldKey: _scaffoldKey,
                                  ),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Colors.green,
                                  ),
                                  secondaryBackground: Container(
                                    color: Colors.red,
                                    child: Align(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            " Delete",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.centerRight,
                                    ),
                                  ),
                                  confirmDismiss: (direction) async {
                                    final result = await showDialog<int>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return CustomAlertDialog(
                                            text: 'Are you sure you want to delete' +
                                                ' the product: ${_products[index].name}');
                                      },
                                    );
                                    if (result == 0) {
                                      return false;
                                    } else {
                                      deleteProduct(_products[index].id);
                                      return true;
                                    }
                                  },
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(2, 128, 144, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromRGBO(240, 243, 189, 10),
                              blurRadius: 4.0),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "There are no products.",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontStyle: FontStyle.italic),
                          ),
                          CustomButton(
                            actionOnpressed: getProducts(),
                            text: 'refresh',
                            backgroundColor: Color.fromRGBO(240, 243, 189, 10),
                            textColor: Colors.black,
                          ),
                        ],
                      ),
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(240, 243, 189, 10),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProduct(),
            ),
          );
          if (result != null) {
            //Show message
            _scaffoldKey.currentState
                .showSnackBar(showSnackBar(result, Colors.green[500]));
            //Refresh list of products
            getProducts();
          }
        },
      ),
    );
  }
}
