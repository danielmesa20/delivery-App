import 'dart:io';
import 'package:brew_crew/Models/Commerce.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/Constants.dart';
import 'package:brew_crew/shared/CustomAlertDialog.dart';
import 'package:brew_crew/shared/CustomButton.dart';
import 'package:brew_crew/shared/CustomCircleAvatar.dart';
import 'package:brew_crew/shared/CustomTitle.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:brew_crew/shared/Loading.dart';
import 'package:flutter/material.dart';

class ProfileData extends StatefulWidget {
  ProfileData({Key key}) : super(key: key);

  @override
  _ProfileDataState createState() => _ProfileDataState();
}

class _ProfileDataState extends State<ProfileData> {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final _database = DatabaseService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _nameC = new TextEditingController();
  TextEditingController _emailC = new TextEditingController();
  Commerce _commerce;
  File _image;

  //Load products
  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  //Get Commerce data
  void getProfileData() async {
    //Recived result Api
    dynamic result = await _database.getCommerceData();

    if (result['err'] == null) {
      setState(() {
        _commerce = Commerce.fromJson(result['commerce']);
        _nameC.text = _commerce.name;
        _emailC.text = _commerce.email;
      });
    } else {
      //Show the snackbar with the err
      _scaffoldKey.currentState
          .showSnackBar(showSnackBar(result['err'], Colors.red));
    }
  }

  //Update image
  void updateImage(File img) {
    setState(() => _image = img);
  }

  void changeCommerceData() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(2, 128, 144, 1),
      body: SafeArea(
        child: Center(
          child: _commerce == null
              ? Loading()
              : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: LayoutBuilder(
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
                                    text: "Profile",
                                  ),
                                  SizedBox(height: 20.0),
                                  CustomCircleAvatar(
                                    color: Color.fromRGBO(0, 168, 150, 100),
                                    url: _commerce.imageURL,
                                    action: updateImage,
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
                                      if (val.isEmpty) return 'Enter an name';
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 20.0),
                                  TextFormField(
                                    controller: _emailC,
                                    keyboardType: TextInputType.emailAddress,
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: inputDecoration('Email'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.25,
                                    ),
                                    validator: (val) {
                                      if (val.isEmpty) return 'Enter an email';
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 20.0),
                                  CustomButton(
                                    backgroundColor:
                                        Color.fromRGBO(0, 168, 150, 1),
                                    text: "UPDATE",
                                    textColor: Colors.white,
                                    actionOnpressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        if (_image != null) {
                                          final result = await showDialog<int>(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return CustomAlertDialog(
                                                  text:
                                                      'Are you sure you want to update the' +
                                                          'data?');
                                            },
                                          );
                                          //Answer yes in the AlertDialog
                                          if (result == 1) changeCommerceData();
                                        } else {
                                          _scaffoldKey.currentState
                                              .showSnackBar(
                                            showSnackBar(
                                              'Dont Image Selected',
                                              Colors.red,
                                            ),
                                          );
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
      ),
    );
  }
}
