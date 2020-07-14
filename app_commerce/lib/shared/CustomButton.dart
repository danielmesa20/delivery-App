import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color backgroundColor, textColor, shapeColor;
  final Function actionOnpressed;

  CustomButton(
      {this.text,
      this.backgroundColor,
      this.textColor,
      this.shapeColor,
      this.actionOnpressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: backgroundColor,
      elevation: 0.0,
      padding: EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(8.0),
        side: shapeColor != null
            ? BorderSide(color: shapeColor, width: 2.0) 
            : BorderSide(color: Colors.transparent),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16
        ),
      ),
      onPressed: () => actionOnpressed(),
    );
  }
}
