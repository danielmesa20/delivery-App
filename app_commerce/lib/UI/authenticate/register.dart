import 'dart:io';
import 'package:brew_crew/Data/select_data.dart';
import 'package:brew_crew/blocs/register/bloc/register_bloc.dart';
import 'package:brew_crew/shared/CountryBottonSheet.dart';
import 'package:brew_crew/shared/CustomAlertDialog.dart';
import 'package:brew_crew/shared/CustomButton.dart';
import 'package:brew_crew/shared/CustomCircleAvatar.dart';
import 'package:brew_crew/shared/CustomTitle.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:brew_crew/shared/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class Register extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  Register(this.scaffoldKey);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //Variables
  bool _hidden = true;
  String _category = '', _country = '', _state = '';
  TextEditingController _emailC = TextEditingController();
  TextEditingController _passwordC = TextEditingController();
  TextEditingController _nameC = TextEditingController();
  List<String> _categories = listCategories;
  List<String> _states = listStatesColombia;
  File _image;

  //Commerce Data
  Map commerceData() {
    Map commerce = {
      'email': _emailC.text,
      'password': _passwordC.text,
      'category': _category,
      'country': _country,
      'state': _state,
      'name': _nameC.text,
      'image': _image,
    };
    return commerce;
  }

  //Confirm message
  void confirmMessage() async {
    //Confirm message
    final result = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
            text: 'Are you sure you want to register ' + 'with these data?');
      },
    );
    //Answer yes in the AlertDialog
    if (result == 1) {
      BlocProvider.of<RegisterBloc>(context).add(
        DoRegisterEvent(commerceData: commerceData()),
      );
    } else {
      BlocProvider.of<RegisterBloc>(context).add(ResetState());
    }
  }

  //Update image
  void updateImage(File img) => setState(() => _image = img);

  void showScrollPicker(String text, List<String> items, String item) {
    showMaterialScrollPicker(
      context: context,
      title: text,
      items: items,
      selectedItem: item,
      backgroundColor: Color.fromRGBO(0, 168, 150, 10),
      buttonTextColor: Colors.white,
      confirmText: "SELECT",
      headerColor: Color.fromRGBO(2, 89, 111, 1),
      headerTextColor: Colors.white,
      onChanged: (value) => setState(
        () => {
          if (item == '_category') _category = value else _state = value,
        },
      ),
    );
  }

  //Clear Form
  clearForm() {
    _emailC.clear();
    _passwordC.clear();
    _nameC.clear();
    setState(() {
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

  void _showCountryPanel() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0.0,
      isDismissible: true,
      builder: (context) {
        return CountryBottonSheet();
      },
    );
    if (result != null) {
      setState(() => {
            _country = result,
            _state = '',
          });
      BlocProvider.of<RegisterBloc>(context)
          .add(ChangeListOptionsEvent(country: result));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is ErrorBlocState) {
              //Show Error message
              widget.scaffoldKey.currentState.showSnackBar(showSnackBar(
                state.error,
                Colors.red,
              ));
            } else if (state is RegisterSuccess) {
              //Pop Loading Dialog
              Navigator.pop(context);
              //Clean Form fields
              clearForm();
              //Show completed message
              widget.scaffoldKey.currentState.showSnackBar(showSnackBar(
                'Register completed.',
                Colors.greenAccent[700],
              ));
            } else if (state is ChangeListOptinonsState) {
              setState(() => {
                    _states = state.options,
                    _state = '',
                  });
            } else if (state is LoadingState) {
              //Show Loading  Dialog
              onLoading(context);
            } else if (state is RegisterFailed) {
              //Pop Loading Dialog
              Navigator.pop(context);
              //Show Error message
              widget.scaffoldKey.currentState.showSnackBar(showSnackBar(
                state.error,
                Colors.red,
              ));
            } else if (state is ValidateFieldsCompleted) {
              confirmMessage();
            }
          },
          child: BlocBuilder<RegisterBloc, RegisterState>(
            builder: (context, state) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  var width = (constraints.maxWidth / 8);
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        CustomTitle(
                          size: width * 1.15,
                          text: "Register",
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
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _passwordC,
                          textAlignVertical: TextAlignVertical.top,
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.25,
                          ),
                          decoration: inputDecoration(
                            'Password',
                            Icons.security,
                            'Must have more than 6 characters.',
                          ).copyWith(
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
                          ),
                          obscureText: _hidden,
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
                        ),
                        SizedBox(height: 20.0),
                        CustomButton(
                          actionOnpressed: () => showScrollPicker(
                            "Select one Category",
                            _categories,
                            '_category',
                          ),
                          backgroundColor: Color.fromRGBO(2, 89, 111, 100),
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
                          actionOnpressed: () => _showCountryPanel(),
                          backgroundColor: Color.fromRGBO(2, 89, 111, 100),
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
                          actionOnpressed: () => showScrollPicker(
                            "Select one State",
                            _states,
                            '_state',
                          ),
                          backgroundColor: Color.fromRGBO(2, 89, 111, 100),
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
                          actionOnpressed: () {
                            //Validate event
                            BlocProvider.of<RegisterBloc>(context).add(
                              ValidateEvent(commerceData: commerceData()),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
