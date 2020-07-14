import 'dart:io';
import 'package:brew_crew/Data/select_data.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/CustomAlertDialog.dart';
import 'package:brew_crew/shared/CustomButton.dart';
import 'package:brew_crew/shared/CustomCircleAvatar.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:brew_crew/shared/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class Register extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  Register(this.scaffoldKey);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  bool _hidden = true;
  String _category = '', _country = '', _state = '';
  TextEditingController _emailC = new TextEditingController();
  TextEditingController _passwordC = new TextEditingController();
  TextEditingController _nameC = new TextEditingController();
  List<String> _countries = listCountries;
  List<String> _categories = listCategories;
  List<String> _states = listStatesColombia;
  File _image;

  //Create commerce data
  createCommerce() async {
    //Show Dialog
    onLoading(context);

    //New Commerce data
    Map commerce = {
      'email': _emailC.text,
      'password': _passwordC.text,
      'category': _category,
      'country': _country,
      'state': _state,
      'name': _nameC.text,
      'image': _image,
    };

    //API result
    var result = await _auth.signUp(commerce);

    //Pop Dialog
    Navigator.pop(context);

    if (result['err'] != null) {
      //Show the snackbar with the err
      widget.scaffoldKey.currentState
          .showSnackBar(showSnackBar(result['err'], Colors.red));
    } else {
      //Clear Form
      clearForm();

      //Show the snackbar with the message
      widget.scaffoldKey.currentState
          .showSnackBar(showSnackBar('Registration completed.', Colors.green));
    }
  }

  //Change State Select Options
  changeListState(String nameSelect) {
    if (nameSelect == 'Venezuela') {
      setState(() => {_states = listStatesVenezuela, _state = ''});
    } else {
      setState(() => {_states = listStatesColombia, _state = ''});
    }
  }

  //Validate inputs
  bool validate() {
    //Empty select
    if (_category.length == 0 || _country.length == 0 || _state.length == 0) {
      widget.scaffoldKey.currentState.showSnackBar(showSnackBar(
          'Select Category, Country and State', Colors.yellow[700]));
      return false;
    } else if (_image == null) {
      widget.scaffoldKey.currentState.showSnackBar(
        showSnackBar(
          'Dont Image Selected',
          Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  //Update image
  void updateImage(File img) {
    setState(() => _image = img);
  }

  //Clear Form
  clearForm() {
    _emailC.clear();
    _passwordC.clear();
    _nameC.clear();
    setState(() {
      _image = null;
      _category = '';
      _country = '';
      _state = '';
    });
  }

  // Clean controller
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    _nameC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
                          "Register Your Commerce",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30.0,
                              fontFamily: 'Prima',
                              letterSpacing: 1.5,
                              color: Color.fromRGBO(240, 243, 189, 1)),
                        ),
                        SizedBox(height: 20.0),
                        CustomCircleAvatar(
                          color: Color.fromRGBO(0, 168, 150, 100),
                          action: updateImage,
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _emailC,
                          keyboardType: TextInputType.emailAddress,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: inputDecoration('Email', Icons.email),
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.25,
                          ),
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Enter an email';
                            } else if (!validateEmail(val)) {
                              return 'Enter an valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _passwordC,
                          textAlignVertical: TextAlignVertical.top,
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.25,
                          ),
                          decoration:
                              inputDecoration('Password', Icons.security)
                                  .copyWith(
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _hidden == true
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.white70,
                                        ),
                                        onPressed: () =>
                                            setState(() => _hidden = !_hidden),
                                      ),
                                      helperText:
                                          'Must have more than 6 characters.',
                                      helperStyle: TextStyle(
                                          color: Colors.grey[300],
                                          fontSize: 14)),
                          obscureText: _hidden,
                          validator: (val) {
                            if (val.isEmpty) {
                              return 'Enter a password';
                            } else if (val.length < 6) {
                              return 'Enter a password 6+ chars long';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _nameC,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: inputDecoration('Name'),
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.25,
                          ),
                          validator: (val) {
                            if (val.isEmpty) return 'Enter an name';
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        CustomButton(
                          actionOnpressed: () => showMaterialScrollPicker(
                            context: context,
                            title: "Select one Category",
                            items: _categories,
                            selectedItem: _category,
                            backgroundColor: Color.fromRGBO(0, 168, 150, 10),
                            buttonTextColor: Colors.white,
                            confirmText: "SELECT",
                            headerColor: Color.fromRGBO(2, 89, 111, 1),
                            headerTextColor: Colors.white,
                            onChanged: (value) =>
                                setState(() => _category = value),
                          ),
                          backgroundColor: Color.fromRGBO(2, 89, 111, 1),
                          text: _category.isEmpty
                              ? "Select One Category"
                              : "Selected: $_category",
                          textColor: Colors.white,
                          shapeColor: _category.isEmpty
                              ? Colors.redAccent[700]
                              : Colors.greenAccent[700],
                        ),
                        SizedBox(height: 10.0),
                        CustomButton(
                          actionOnpressed: () => showMaterialScrollPicker(
                            context: context,
                            title: "Select one Country",
                            items: _countries,
                            selectedItem: _country,
                            backgroundColor: Color.fromRGBO(2, 89, 111, 1),
                            buttonTextColor: Colors.white,
                            confirmText: "SELECT",
                            headerColor: Color.fromRGBO(0, 168, 150, 10),
                            headerTextColor: Colors.white,
                            onChanged: (value) => {
                              setState(() => {_country = value}),
                              changeListState(value)
                            },
                          ),
                          backgroundColor: Color.fromRGBO(2, 89, 111, 1),
                          text: _country.isEmpty
                              ? "Select One Country"
                              : "Selected: $_country",
                          textColor: Colors.white,
                          shapeColor: _country.isEmpty
                              ? Colors.redAccent[700]
                              : Colors.greenAccent[700],
                        ),
                        SizedBox(height: 10.0),
                        CustomButton(
                          actionOnpressed: () => showMaterialScrollPicker(
                            context: context,
                            title: "Select one State",
                            items: _states,
                            selectedItem: _state,
                            backgroundColor: Color.fromRGBO(2, 89, 111, 1),
                            buttonTextColor: Colors.white,
                            confirmText: "SELECT",
                            headerColor: Color.fromRGBO(0, 168, 150, 10),
                            headerTextColor: Colors.white,
                            onChanged: (value) =>
                                setState(() => _state = value),
                          ),
                          backgroundColor: Color.fromRGBO(2, 89, 111, 1),
                          text: _state.isEmpty
                              ? "Select One State"
                              : "Selected: $_state",
                          textColor: Colors.white,
                          shapeColor: _state.isEmpty
                              ? Colors.redAccent[700]
                              : Colors.greenAccent[700],
                        ),
                        SizedBox(height: 10.0),
                        CustomButton(
                          backgroundColor: Color.fromRGBO(0, 168, 150, 1),
                          text: "Enter",
                          textColor: Colors.white,
                          actionOnpressed: () async {
                            if (_formKey.currentState.validate() &&
                                validate()) {
                              final result = await showDialog<int>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return CustomAlertDialog(
                                      text:
                                          'Are you sure you want to register ' +
                                              'with these data?');
                                },
                              );
                              //Answer yes in the AlertDialog
                              if (result == 1) createCommerce();
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
    );
  }
}
