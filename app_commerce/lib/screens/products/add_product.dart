import 'dart:io';
import 'package:brew_crew/screens/products/image_capture.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/Constants.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

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
  bool _loading = false, _isAvailable = false;
  File _image;
  TextEditingController _nameC = new TextEditingController();
  TextEditingController _descriptionC = new TextEditingController();
  TextEditingController _priceC = new TextEditingController();

  //Create Product
  createProduct() async {
    if (_image != null) {
      //Show LinearProgressIndicator
      setState(() => _loading = true);

      //New Product data
      Map product = {
        'name': _nameC.text,
        'description': _descriptionC.text,
        'price': _priceC.text,
        'image': _image,
        'available': _isAvailable.toString(),
        'commerce_id': 'test_id',
      };

      //API result
      var result = await _database.addProduct(product);

      //Hidden LinearProgressIndicator
      setState(() => _loading = false);

      if (result != null) {
        //Show the snackbar with the err
        _scaffoldKey.currentState
            .showSnackBar(showSnackBar(result, Colors.red));
      } else {
        //Clear Form
        clearForm();
        //Show the snackbar with the message
        _scaffoldKey.currentState.showSnackBar(
            showSnackBar('Add Product completed.', Colors.green[500]));
      }
    } else {
      _scaffoldKey.currentState
          .showSnackBar(showSnackBar('Dont Image Selected', Colors.red));
    }
  }

  //Clear Form
  clearForm() {
    _nameC.clear();
    _priceC.clear();
    _descriptionC.clear();
    setState(() {
      _isAvailable = false;
      _image = null;
    });
  }

  // Limpia el controlador cuando el widget se elimine del árbol de widgets
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
      backgroundColor: Colors.brown[100],
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _loading ? LinearProgressIndicator() : SizedBox(height: 6),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
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
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: _nameC,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: inputDecoration('Product name'),
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
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: inputDecoration('Product price'),
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
                        children: <Widget>[
                          Text(
                            "Product Available",
                            style: TextStyle(fontSize: 17),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        children: [
          SpeedDialChild(
            child: Icon(Icons.camera_alt),
            backgroundColor: Colors.green[800],
            label: 'Enter',
            onTap: () => {
              _formKey.currentState.validate() == true ? createProduct() : null
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.photo),
            backgroundColor: Colors.green,
            label: 'Add Product Image',
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageCapture(),
                ),
              );
              if (result != null) setState(() => _image = result);
            },
          )
        ],
      ),
    );
  }
}
