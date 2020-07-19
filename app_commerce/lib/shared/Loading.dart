import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 5,
        backgroundColor: Color.fromRGBO(0, 168, 150, 10),
      ),
    );
  }
}
