import 'package:flutter/material.dart';

// Function to Validate email
bool validateEmail(String email) {
  bool valid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  return valid;
}

// Function Show SnackBar
showSnackBar(String text, Color color) {
  return SnackBar(
    content: Text(
      text,
      textAlign: TextAlign.center,
    ),
    backgroundColor: color
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

//Show Dialog Loader
void onLoading(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Center(
              child: Column(children: [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Please Wait....",
                  style: TextStyle(color: Colors.blueAccent),
                )
              ]),
            ),
          ],
        );
      },
    );
  }

