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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.greenAccent,
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                text: "SignIn",
              ),
              Tab(
                text: "SignUp",
              ),
            ],
          ),
          title: Text('App Delivery Commerce Alpha'),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: TabBarView(
          children: [SignInWithEmail(_scaffoldKey), Register(_scaffoldKey)],
        ),
      ),
    );
  }
}
