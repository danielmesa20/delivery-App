import 'dart:io';
import 'package:brew_crew/Data/messages.dart';
import 'package:brew_crew/blocs/addProduct/bloc/addproduct_bloc.dart';
import 'package:brew_crew/shared/Constants.dart';
import 'package:brew_crew/shared/CustomAlertDialog.dart';
import 'package:brew_crew/shared/CustomButton.dart';
import 'package:brew_crew/shared/CustomCircleAvatar.dart';
import 'package:brew_crew/shared/CustomTitle.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductProvider extends StatelessWidget {
  const AddProductProvider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddproductBloc(),
      child: AddProductScreen(),
    );
  }
}

class AddProductScreen extends StatefulWidget {
  AddProductScreen({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProductScreen> {
  //Variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _nameC = new TextEditingController();
  TextEditingController _descriptionC = new TextEditingController();
  TextEditingController _priceC = new TextEditingController();
  bool _isAvailable = false;
  File _image;

  void confirMessage() async {
    final result = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(text: CONFIRM_ADD_PRODUCT);
      },
    );
    if (result == 1) {
      Map data = {
        'name': _nameC.text,
        'description': _descriptionC.text,
        'price': _priceC.text,
        'image': _image,
        'available': _isAvailable.toString()
      };
      BlocProvider.of<AddproductBloc>(context).add(AddProductEvent(data: data));
    }
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(2, 128, 144, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocListener<AddproductBloc, AddproductState>(
            listener: (context, state) {
              if (state is LoadingState) {
                onLoading(context);
              } else if (state is AddProductErrorState) {
                if (state.hide) Navigator.pop(context);
                //Show the snackbar with the err
                _scaffoldKey.currentState
                    .showSnackBar(showSnackBar(state.error, Colors.red));
              } else if (state is SuccesValidateState) {
                confirMessage();
              } else if (state is SuccessAddState) {
                //Pop Dialog
                Navigator.pop(context);
                //Go to List Products screen
                Navigator.pop(context, 'Add Product completed.');
              }
            },
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
                      CustomTitle(
                        size: width * 1.15,
                        text: "Add Product",
                      ),
                      SizedBox(height: 20.0),
                      CustomCircleAvatar(
                        color: _isAvailable
                            ? Colors.greenAccent[700]
                            : Colors.redAccent,
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
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _priceC,
                        maxLength: 6,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: inputDecoration('Product price'),
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.25,
                        ),
                      ),
                      SizedBox(height: 10.0),
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
                        actionOnpressed: () {
                          //New Product data
                          Map data = {
                            'name': _nameC.text,
                            'description': _descriptionC.text,
                            'price': _priceC.text,
                            'image': _image,
                          };
                          BlocProvider.of<AddproductBloc>(context)
                              .add(ValidateFieldsEvent(data: data));
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
