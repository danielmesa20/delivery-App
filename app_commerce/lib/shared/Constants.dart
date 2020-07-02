import 'package:flutter/material.dart';

// InputDecoration
InputDecoration inputDecoration(String text, [IconData icon]) {
  return InputDecoration(
    prefixIcon: icon != null
        ? Icon(
            icon,
            color: Colors.black,
            size: 20.0,
          )
        : null,
    hintText: text,
    hintStyle: TextStyle(
      color: Colors.grey,
    ),
    fillColor: Color.fromRGBO(128, 172, 164, 0),
    filled: true,
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.brown,
        width: 2.0,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.pink,
        width: 2.0,
      ),
    ),
  );
}
