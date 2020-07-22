import 'package:brew_crew/Data/select_data.dart';
import 'package:brew_crew/shared/CountryBottonSheet.dart';
import 'package:brew_crew/shared/CustomAlertDialog.dart';
import 'package:brew_crew/shared/CustomButton.dart';
import 'package:brew_crew/shared/CustomTitle.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';

class PickLocationScreen extends StatefulWidget {
  PickLocationScreen({Key key}) : super(key: key);

  @override
  _PickLocationScreenState createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  //Variables
  String _country = '', _state = '';
  List<String> _states = listStatesColombia;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
          if (item == '_category') _country = value else _state = value,
        },
      ),
    );
  }

  //Show country panel
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
      if (result == 'Venezuela') {
        _states = listStatesVenezuela;
      } else {
        _states = listStatesColombia;
      }
    }
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
      Map data = {"country": _country, "state": _state};
      Navigator.pop(context, data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(2, 128, 144, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(2, 128, 144, 1),
        elevation: 0.0,
      ),
      body: Center(
        child: SingleChildScrollView(
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
                      size: width * 1.2,
                      text: "Pick Your Location",
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
                      text: "Complete registration",
                      textColor: Colors.white,
                      actionOnpressed: () {
                        if (_country.length != 0 && _state.length != 0) {
                          confirmMessage();
                        } else {
                          _scaffoldKey.currentState.showSnackBar(
                            showSnackBar(
                              'Select One country and State',
                              Colors.red,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
