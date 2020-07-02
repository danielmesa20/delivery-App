import 'package:brew_crew/screens/authenticate/register.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/CustomButton.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:brew_crew/shared/Constants.dart';
import 'package:flutter/material.dart';

class SignInWithEmail extends StatefulWidget {
  @override
  _SignInWithEmailState createState() => _SignInWithEmailState();
}

class _SignInWithEmailState extends State<SignInWithEmail> {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false, _hidden = true;
  TextEditingController _emailC = new TextEditingController();
  TextEditingController _passwordC = new TextEditingController();

  signIn() async {
    //Show LinearProgressIndicator
    setState(() => _loading = true);
    //Result from API
    dynamic result = await _auth.signIn( _emailC.text, _passwordC.text);
    //Hidden LinearProgressIndicator
    setState(() => _loading = false);
    if(result == null){
      //Go to Home Screen
      changeScreen(context, Home());
    }else{
      //Show Error message
      _scaffoldKey.currentState
          .showSnackBar(showSnackBar(result, Colors.red));
    }
  }

  // Limpia el controlador cuando el widget se elimine del árbol de widgets
   void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.brown[100],
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _loading ? LinearProgressIndicator() : SizedBox(height: 6),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      Text(
                        "SIGN IN WITH EMAIL",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 35.0,
                          fontFamily: 'Prima',
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: _emailC,
                        keyboardType: TextInputType.emailAddress,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: inputDecoration(
                            'Enter Your Email Here', Icons.email),
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter an email';
                          } else if (!validateEmail(val)) {
                            return 'Enter an valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: _passwordC,
                        textAlignVertical: TextAlignVertical.bottom,
                        decoration: inputDecoration(
                          'Enter Your Password Here',
                          Icons.security,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _hidden == true
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                            onPressed: () => setState(() => _hidden = !_hidden),
                          ),
                        ),
                        obscureText: _hidden,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Enter an password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      CustomButton(
                        backgroundColor: Colors.pink,
                        text: "Enter",
                        textColor: Colors.white,
                        actionOnpressed: () {
                          if (_formKey.currentState.validate()) signIn();
                        },
                      ),
                      CustomButton(
                        backgroundColor: Colors.blue,
                        text: "Go to Register",
                        textColor: Colors.white,
                        actionOnpressed: () =>
                            changeScreen(context, Register()),
                      ),
                      CustomButton(
                        backgroundColor: Colors.brown[100],
                        text: "I forgot my password",
                        textColor: Colors.white,
                        actionOnpressed: () async {
                          if (_emailC.text == '' || _emailC.text == null || !validateEmail(_emailC.text)) {
                            _scaffoldKey.currentState.showSnackBar(showSnackBar(
                                'Please supply a valid email.', Colors.yellow[700]));
                          } else {
                            _scaffoldKey.currentState.showSnackBar(showSnackBar(
                                'This function has not been implemented',
                                Colors.yellow[700]));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
