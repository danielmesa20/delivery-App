import 'package:flutter/material.dart';

import 'Loading.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color.fromRGBO(2, 128, 144, 1),
            Color.fromRGBO(0, 168, 150, 10),
          ],
        ),
      ),
      child: Loading(),
    );
  }
}
