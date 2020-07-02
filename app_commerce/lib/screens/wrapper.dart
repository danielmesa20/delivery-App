import 'package:brew_crew/screens/authenticate/sign_in_email.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:brew_crew/shared/Loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  //Get token auth
  SharedPreferences sharedPreferences;

   @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      changeScreen(context, SignInWithEmail());
    }else{
      changeScreen(context, Home());
    }
  }

  @override
  Widget build(BuildContext context){
    return Loading();
  }
}