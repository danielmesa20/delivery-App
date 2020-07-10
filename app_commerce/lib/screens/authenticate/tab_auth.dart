import 'package:brew_crew/screens/authenticate/register.dart';
import 'package:brew_crew/screens/authenticate/sign_in_email.dart';
import 'package:flutter/material.dart';

class TabAuth extends StatefulWidget {
  @override
  _TabAuthState createState() => _TabAuthState();
}

class _TabAuthState extends State<TabAuth> {
  //Variables
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: Color.fromRGBO(2, 128, 144, 1),
          appBar: TabBar(
            labelColor: Color.fromRGBO(240, 243, 189, 1),
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.25,
              fontSize: 17,
            ),
            indicatorColor: Color.fromRGBO(0, 168, 150, 100),
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(text: "SignIn"),
              Tab(text: "SignUp"),
            ],
          ),
          body: TabBarView(
            children: [SignInWithEmail(_scaffoldKey), Register(_scaffoldKey)],
          ),
        ),
      ),
    );
  }
}
