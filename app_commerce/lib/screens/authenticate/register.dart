import 'package:brew_crew/Data/Countries.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/CustomButton.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:brew_crew/shared/Constants.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

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
  List<DropdownMenuItem> _countries = [];
  List<DropdownMenuItem> _categories = [];
  List<DropdownMenuItem> _states = [];

  @override
  void initState() {
    for (final element in EnumToString.toList(List_Countries.values)) {
      _countries.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    }
    for (final element in EnumToString.toList(List_Categories.values)) {
      _categories.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    }
    for (final element in EnumToString.toList(List_State_Colombia.values)) {
      _states.add(DropdownMenuItem(
        child: Text(element),
        value: element,
      ));
    }
    super.initState();
  }

  //Create commerce data
  createCommerceData() async {
    //Show Dialog
    onLoading(context);

    //New Commerce data
    Map commerce = {
      'email': _emailC.text,
      'password': _passwordC.text,
      'category': _category,
      'country': _country,
      'state': _state,
      'name': _nameC.text
    };

    //API result
    dynamic result = await _auth.signUp(commerce);

    //Pop Dialog
    Navigator.pop(context);

    if (result != null) {
      //Show the snackbar with the err
      widget.scaffoldKey.currentState
          .showSnackBar(showSnackBar(result, Colors.red));
    } else {
      //Clear Form
      clearForm();

      //Hidden Keyboard
      SystemChannels.textInput.invokeMethod('TextInput.hide');

      //Show the snackbar with the message
      widget.scaffoldKey.currentState
          .showSnackBar(showSnackBar('Registration completed.', Colors.green));
    }
  }

  //Change State Select Options
  changeListState(String nameSelect) {
    List<DropdownMenuItem> aux = [];
    if (nameSelect == 'Venezuela') {
      for (final element in EnumToString.toList(List_State_Venezuela.values)) {
        aux.add(DropdownMenuItem(
          child: Text(element),
          value: element,
        ));
      }
    } else {
      for (final element in EnumToString.toList(List_State_Colombia.values)) {
        aux.add(DropdownMenuItem(
          child: Text(element),
          value: element,
        ));
      }
    }
    setState(() {
      _states = aux;
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
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                          color: Color.fromRGBO(240, 243, 189, 1)),
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
                      style:
                          TextStyle(color: Colors.white70, letterSpacing: 1.25),
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
                      style:
                          TextStyle(color: Colors.white70, letterSpacing: 1.25),
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
                      decoration: inputDecoration(
                        'Enter Your Name Here',
                      ),
                      style: TextStyle(
                        color: Colors.white70,
                        letterSpacing: 1.25,
                      ),
                      validator: (val) {
                        if (val.isEmpty) return 'Enter an name';
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    SearchableDropdown.single(
                      items: _categories,
                      value: _category,
                      hint: "Select one Category",
                      searchHint: "Categories",
                      isExpanded: true,
                      menuBackgroundColor: Color.fromRGBO(0, 168, 150, 100),
                      onChanged: (value) {
                        setState(() => _category = value);
                      },
                      style: TextStyle(
                          letterSpacing: 1.25,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                          fontSize: 17),
                      onClear: () {
                        setState(() => _category = '');
                      },
                    ),
                    SizedBox(height: 20.0),
                    SearchableDropdown.single(
                      items: _countries,
                      value: _country,
                      hint: "Select one Country",
                      searchHint: "Countries",
                      menuBackgroundColor: Color.fromRGBO(0, 168, 150, 100),
                      onChanged: (value) {
                        setState(() => _country = value);
                        changeListState(_country);
                      },
                      isExpanded: true,
                      style: TextStyle(
                          letterSpacing: 1.25,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                          fontSize: 17),
                      onClear: () {
                        setState(() => _country = '');
                      },
                    ),
                    SizedBox(height: 20.0),
                    SearchableDropdown.single(
                      items: _states,
                      value: _state,
                      hint: "Select one State",
                      searchHint: "States",
                      menuBackgroundColor: Color.fromRGBO(0, 168, 150, 100),
                      onChanged: (value) => setState(() => _state = value),
                      isExpanded: true,
                      style: TextStyle(
                          letterSpacing: 1.25,
                          color: Colors.white70,
                          fontStyle: FontStyle.italic,
                          fontSize: 17),
                      onClear: () => setState(() => _state = ''),
                    ),
                    SizedBox(height: 20.0),
                    CustomButton(
                      backgroundColor: Color.fromRGBO(0, 168, 150, 1),
                      text: "Enter",
                      textColor: Colors.white,
                      actionOnpressed: () {
                        if (_formKey.currentState.validate()) {
                          if (_category.length == 0 ||
                              _country.length == 0 ||
                              _state.length == 0) {
                            widget.scaffoldKey.currentState.showSnackBar(
                                showSnackBar(
                                    'Select Category, Country and State',
                                    Colors.yellow[700]));
                          } else {
                            createCommerceData();
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
    );
  }
}
