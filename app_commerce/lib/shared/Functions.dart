import 'package:flutter/material.dart';

// Function to Validate email
bool validateEmail(String email) {
  bool valid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  return valid;
}

// Function Show SnackBar
showSnackBar(String text, Color backgroundColor) {
  return SnackBar(
    content: Text(
      text,
      textAlign: TextAlign.center,
    ),
    backgroundColor: backgroundColor
  );
}

// Go to Login Screen
changeScreen(context, Widget newScreen) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => newScreen,
    ),
  );
}
