import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  final Function action;
  CustomSwitch({this.action});

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool _isAvailable;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                widget.action(_isAvailable);
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
              inactiveTrackColor: Colors.red[300],
              inactiveThumbColor: Colors.redAccent,
            ),
          ],
    );
  }
}
