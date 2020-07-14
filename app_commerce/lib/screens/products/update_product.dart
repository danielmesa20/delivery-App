import 'dart:io';
import 'package:brew_crew/models/Product.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/Constants.dart';
import 'package:brew_crew/shared/CustomAlertDialog.dart';
import 'package:brew_crew/shared/CustomButton.dart';
import 'package:brew_crew/shared/CustomCircleAvatar.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:flutter/material.dart';

class UpdateProduct extends StatefulWidget {
  final Product product;
  UpdateProduct({this.product});
  @override
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  //Variables
  final _database = DatabaseService();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _nameC = new TextEditingController();
  TextEditingController _descriptionC = new TextEditingController();
  TextEditingController _priceC = new TextEditingController();
  bool _isAvailable;
  File _image;

  @override
  void initState() {
    super.initState();
    getValues();
  }

  //Get data of the product
  getValues() {
    setState(() {
      _nameC.text = widget.product.name;
      _priceC.text = widget.product.price.toString();
      _descriptionC.text = widget.product.description;
      _isAvailable = widget.product.available;
    });
  }

//Update product
  updateProduct() async {
    //Show Dialog
    onLoading(context);

    //New Product data
    Map product = {
      'name': _nameC.text,
      'description': _descriptionC.text,
      'price': _priceC.text,
      'available': _isAvailable.toString(),
      'image': _image,
      'id': widget.product.id,
      'imageURL': widget.product.imageURL,
      'public_id': widget.product.publicId,
      'commerce_id': widget.product.commerceId
    };

    //API result
    var result = await _database.updateProduct(product);

    //Pop Dialog
    Navigator.pop(context);

    if (result['err'] != null) {
      //Show the snackbar with the err
      _scaffoldKey.currentState
          .showSnackBar(showSnackBar(result['err'], Colors.red));
    } else {
      //Go to List Products screen
      Navigator.pop(context, 'Update Product completed.');
    }
  }

  //Check if data change
  bool validateChanges() {
    if (_image != null) {
      return true;
    } else if (widget.product.name != _nameC.text ||
        widget.product.description != _descriptionC.text ||
        widget.product.price.toString() != _priceC.text ||
        widget.product.available != _isAvailable) {
      return true;
    }
    return false;
  }

  //Update image
  void updateImage(File img) {
    setState(() => _image = img);
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
                child: LayoutBuilder(builder: (context, constraints) {
                  var width = (constraints.maxWidth / 8);
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: width, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        Text(
                          "Update Product",
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
                          url: widget.product.imageURL,
                          action: updateImage,
                          scaffoldKey: _scaffoldKey,
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _nameC,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: inputDecoration('Name'),
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
                          textAlignVertical: TextAlignVertical.top,
                          decoration: inputDecoration('Description'),
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
                          decoration: inputDecoration('Price'),
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
                              "Available",
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
                              inactiveThumbColor: Colors.red,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                        CustomButton(
                          backgroundColor: Color.fromRGBO(0, 168, 150, 1),
                          text: "UPDATE",
                          textColor: Colors.white,
                          actionOnpressed: () async {
                            if (_formKey.currentState.validate()) {
                              final result = await showDialog<int>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return CustomAlertDialog(
                                      text: 'Are you sure you want to update the' +
                                          'product with those characteristics?');
                                },
                              );
                              //Answer yes in the AlertDialog
                              if (result == 1) {
                                if (validateChanges()) {
                                  updateProduct();
                                } else {
                                  _scaffoldKey.currentState.showSnackBar(
                                      showSnackBar('Nothing to update',
                                          Colors.yellowAccent[700]));
                                }
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
