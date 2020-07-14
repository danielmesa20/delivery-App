import 'package:flutter/material.dart';

// InputDecoration
InputDecoration inputDecoration(String text, [IconData icon]) {
  return InputDecoration(
    prefixIcon: icon != null
        ? Icon(
            icon,
            color: Color.fromRGBO(0, 168, 150, 10),
            size: 20.0,
          )
        : null,
    labelText: text,
    labelStyle: TextStyle(
      color: Colors.white70,
    ),
    fillColor: Color.fromRGBO(2, 89, 111, 126),
    filled: true,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(5, 102, 141, 100),
        width: 2.0,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.pink,
        width: 2.0,
      ),
    ),
    counterStyle: TextStyle(
      color: Colors.white,
      letterSpacing: 1.25,
    ),
  );
}
