import 'dart:io';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/Constants.dart';
import 'package:brew_crew/shared/CustomAlertDialog.dart';
import 'package:brew_crew/shared/CustomButton.dart';
import 'package:brew_crew/shared/CustomCircleAvatar.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  //Variables
  final _database = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _nameC = new TextEditingController();
  TextEditingController _descriptionC = new TextEditingController();
  TextEditingController _priceC = new TextEditingController();
  bool _isAvailable = false;
  File _image;

  //Create Product
  createProduct() async {
    //Show Dialog
    onLoading(context);

    //New Product data
    Map product = {
      'name': _nameC.text,
      'description': _descriptionC.text,
      'price': _priceC.text,
      'image': _image,
      'available': _isAvailable.toString()
    };

    //API result
    var result = await _database.addProduct(product);

    //Pop Dialog
    Navigator.pop(context);

    if (result['err'] != null) {
      //Show the snackbar with the err
      _scaffoldKey.currentState
          .showSnackBar(showSnackBar(result['err'], Colors.red));
    } else {
      //Go to List Products screen
      Navigator.pop(context, 'Add Product completed.');
    }
  }

  //Update image
  void updateImage(File img) {
    setState(() => _image = img);
  }

  //Update _isAvailable
  void updateAvailable(bool available) {
    setState(() => _isAvailable = available);
  }

  // Clean controllers
  void dispose() {
    _nameC.dispose();
    _descriptionC.dispose();
    _priceC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color circleColor =
        _isAvailable ? Colors.greenAccent[700] : Colors.redAccent;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(2, 128, 144, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    var width = (constraints.maxWidth / 8);
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: width, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          Text(
                            "Add Product",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30.0,
                                fontFamily: 'Prima',
                                letterSpacing: 1.5,
                                color: Color.fromRGBO(240, 243, 189, 1)),
                          ),
                          SizedBox(height: 20.0),
                          CustomCircleAvatar(
                            color: circleColor,
                            action: updateImage,
                            scaffoldKey: _scaffoldKey,
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: _nameC,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: inputDecoration('Product name'),
                            maxLength: 30,
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.25,
                            ),
                            validator: (val) {
                              if (val.isEmpty) return 'Enter an product name';
                              return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: _descriptionC,
                            keyboardType: TextInputType.multiline,
                            maxLines: 3,
                            maxLength: 300,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: inputDecoration('Product description'),
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.25,
                            ),
                            validator: (val) {
                              if (val.isEmpty)
                                return 'Enter an product description';
                              return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _priceC,
                            maxLength: 4,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: inputDecoration('Product price'),
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1.25,
                            ),
                            validator: (val) {
                              if (val.isEmpty) {
                                return 'Enter an product price.';
                              } else if (double.parse(val) <= 0) {
                                return 'Enter a price greater than 0.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Product Available",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                              Switch(
                                value: _isAvailable,
                                onChanged: (value) {
                                  setState(() => _isAvailable = value);
                                },
                                activeTrackColor: Colors.lightGreenAccent,
                                activeColor: Colors.green,
                                inactiveTrackColor: Colors.red[300],
                                inactiveThumbColor: Colors.redAccent,
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          CustomButton(
                            backgroundColor: Color.fromRGBO(0, 168, 150, 1),
                            text: "SAVE",
                            textColor: Colors.white,
                            actionOnpressed: () async {
                              if (_formKey.currentState.validate()) {
                                if (_image != null) {
                                  final result = await showDialog<int>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return CustomAlertDialog(
                                          text: 'Are you sure you want to create the' +
                                              'product with those characteristics?');
                                    },
                                  );
                                  //Answer yes in the AlertDialog
                                  if (result == 1) createProduct();
                                } else {
                                  _scaffoldKey.currentState
                                      .showSnackBar(showSnackBar(
                                    'Dont Image Selected',
                                    Colors.red,
                                  ));
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
