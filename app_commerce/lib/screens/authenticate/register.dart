import 'package:brew_crew/Data/Countries.dart';
import 'package:brew_crew/screens/authenticate/sign_in_email.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/CustomButton.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:brew_crew/shared/SelectCustom.dart';
import 'package:brew_crew/shared/Constants.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _auth = AuthService();
  bool _loading = false, _hidden = true;
  String _category, _country, _state;
  List<String> _countries = EnumToString.toList(List_Countries.values);
  List<String> _categories = EnumToString.toList(List_Categories.values);
  List<String> _states = EnumToString.toList(List_State_Colombia.values);
  TextEditingController _emailC = new TextEditingController();
  TextEditingController _passwordC = new TextEditingController();
  TextEditingController _nameC = new TextEditingController();

  //Create commerce data
  createCommerceData() async {
    //Show LinearProgressIndicator
    setState(() => _loading = true);
    //New Commerce data
    Map user = {
      'email': _emailC.text,
      'password': _passwordC.text,
      'category': _category,
      'country': _country,
      'state': _state,
      'username': _nameC.text
    };
    //API result
    dynamic result = await _auth.registerNewUser(user);
    if (result != null) {
      //Show the snackbar with the err
      _scaffoldKey.currentState.showSnackBar(showSnackBar(result, Colors.red));
    } else {
      //Clear Form
      clearForm();
      //Show the snackbar with the message
      _scaffoldKey.currentState
          .showSnackBar(showSnackBar('Registration completed.', Colors.green));
    }
  }

  //Change State Select Options
  changeListState(String nameSelect) {
    setState(() {
      if (nameSelect == 'Venezuela') {
        _states = EnumToString.toList(List_State_Venezuela.values);
      } else {
        _states = EnumToString.toList(List_State_Colombia.values);
      }
    });
  }

  //Clear Form
  clearForm() {
    _emailC.clear();
    _passwordC.clear();
    _nameC.clear();
  }

  // Limpia el controlador cuando el widget se elimine del árbol de widgets
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    _nameC.dispose();
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
                        "Register Your Commerce",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: 'Prima',
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: _emailC,
                        keyboardType: TextInputType.emailAddress,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: inputDecoration(
                          'Enter Your Email Here',
                          Icons.email,
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
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: inputDecoration(
                          'Enter Your Password Here',
                          Icons.security,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _hidden == true
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () => setState(() => _hidden = !_hidden),
                          ),
                        ),
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
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: inputDecoration('Enter Your Name Here'),
                        validator: (val) {
                          if (val.isEmpty) return 'Enter an name';
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      SelectCustom(
                        nameSelect: 'Category',
                        hint: 'Commerce Category',
                        options: _categories,
                        action: (String value) {
                          setState(() => _category = value);
                        },
                      ),
                      SizedBox(height: 20.0),
                      SelectCustom(
                        nameSelect: 'Country',
                        hint: 'Commerce Country',
                        options: _countries,
                        action: (String value) {
                          changeListState(value);
                          setState(() => _country = value);
                        },
                      ),
                      SizedBox(height: 20.0),
                      SelectCustom(
                        nameSelect: 'State',
                        hint: 'Commerce State',
                        options: _states,
                        action: (String value) {
                          setState(() => _state = value);
                        },
                      ),
                      SizedBox(height: 20.0),
                      CustomButton(
                        backgroundColor: Colors.pink,
                        text: "Enter",
                        textColor: Colors.white,
                        actionOnpressed: () {
                          if (_formKey.currentState.validate()) {
                            if (_category.isEmpty ||
                                _country.isEmpty ||
                                _state.isEmpty) {
                              _scaffoldKey.currentState.showSnackBar(
                                  showSnackBar('Select Category, Country and State', Colors.yellow[700]));
                            } else {
                              createCommerceData();
                            }
                          }
                        },
                      ),
                      CustomButton(
                        backgroundColor: Colors.blue,
                        text: "Go to sign In ",
                        textColor: Colors.white,
                        actionOnpressed: () =>
                            changeScreen(context, SignInWithEmail()),
                      )
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
