import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Function actionOnpressed;

  CustomButton({this.text, this.backgroundColor, this.textColor, this.actionOnpressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: backgroundColor,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(8.0),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
        ),
      ),
      onPressed: () => actionOnpressed(),
    );
  }
}
