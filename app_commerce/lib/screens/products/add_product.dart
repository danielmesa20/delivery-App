import 'dart:io';
import 'dart:math';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/Constants.dart';
import 'package:brew_crew/shared/CustomAlertDialog.dart';
import 'package:brew_crew/shared/CustomButton.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

    if (result != null) {
      //Show the snackbar with the err
      _scaffoldKey.currentState.showSnackBar(showSnackBar(result, Colors.red));
    } else {
      //Go to List Products screen
      Navigator.pop(context, 'Add Product completed.');
    }
  }

  //Get photo from gallery
  Future<void> getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) setState(() => _image = File(pickedFile.path));
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(2, 128, 144, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                      Container(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            var radius = min(constraints.maxHeight / 3,
                                constraints.maxWidth / 3);
                            return CircleAvatar(
                              radius: radius,
                              backgroundColor: Color.fromRGBO(0, 168, 150, 1),
                              child: CircleAvatar(
                                radius: radius - 5,
                                child: RaisedButton(
                                  elevation: 0.0,
                                  color: Color.fromRGBO(2, 89, 111, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    'Upload',
                                    style: TextStyle(
                                      letterSpacing: 1.25,
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  onPressed: () async {
                                    getImage(ImageSource.gallery);
                                  },
                                ),
                                backgroundImage: _image == null
                                    ? AssetImage("assets/imagedontfound.png")
                                    : FileImage(_image),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: _nameC,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: inputDecoration('Product name'),
                        maxLength: 30,
                        style: TextStyle(
                          color: Colors.white70,
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
                        maxLines: 4,
                        maxLength: 300,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: inputDecoration('Product description'),
                        style: TextStyle(
                          color: Colors.white70,
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
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: inputDecoration('Product price'),
                        style: TextStyle(
                          color: Colors.white70,
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
                              color: Colors.grey[400],
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
