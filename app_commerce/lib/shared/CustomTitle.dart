import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String text;
  final double size;
  const CustomTitle({Key key, this.text, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: size * 1.25,
        fontFamily: 'RockBottom',
        letterSpacing: 1.5,
        color: Color.fromRGBO(240, 243, 189, 1),
      ),
    );
  }
}
