import 'package:brew_crew/screens/home/home.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/CustomButton.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:brew_crew/shared/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInWithEmail extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  SignInWithEmail(this.scaffoldKey);

  @override
  _SignInWithEmailState createState() => _SignInWithEmailState();
}

class _SignInWithEmailState extends State<SignInWithEmail> {
  //Variables
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  bool _hidden = true;
  TextEditingController _emailC = new TextEditingController();
  TextEditingController _passwordC = new TextEditingController();

  //SignIn Function
  signIn() async {
    //Show Dialog
    onLoading(context);

    //Result from API
    dynamic result = await _auth.signIn(_emailC.text, _passwordC.text);

    //Pop Dialog
    Navigator.pop(context);

    //Verify Api result
    if (result['err'] == null) {
      //Go to Home Screen
      changeScreen(context, Home());
    } else {
      //Show Error message
      widget.scaffoldKey.currentState
          .showSnackBar(showSnackBar(result['err'], Colors.red));
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
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            LayoutBuilder(
              builder: (context, constraints) {
                var width = (constraints.maxWidth / 8);
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: width),
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
                              color: Color.fromRGBO(240, 243, 189, 1)),
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          controller: _emailC,
                          keyboardType: TextInputType.emailAddress,
                          textAlignVertical: TextAlignVertical.top,
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.25,
                          ),
                          decoration: inputDecoration('Email', Icons.email),
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
                          textAlignVertical: TextAlignVertical.top,
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.25,
                          ),
                          decoration: inputDecoration(
                            'Password',
                            Icons.security,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _hidden == true
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: () =>
                                  setState(() => _hidden = !_hidden),
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
                          backgroundColor: Color.fromRGBO(0, 168, 150, 1),
                          text: "Enter",
                          textColor: Colors.white,
                          actionOnpressed: () {
                            if (_formKey.currentState.validate()) signIn();
                          },
                        ),
                        CustomButton(
                          backgroundColor: Colors.transparent,
                          text: "I forgot my password",
                          textColor: Colors.white,
                          actionOnpressed: () async {
                            if (_emailC.text == '' ||
                                _emailC.text == null ||
                                !validateEmail(_emailC.text)) {
                              widget.scaffoldKey.currentState.showSnackBar(
                                  showSnackBar('Please supply a valid email.',
                                      Colors.yellow[700]));
                            } else {
                              widget.scaffoldKey.currentState.showSnackBar(
                                  showSnackBar(
                                      'This function has not been implemented',
                                      Colors.yellow[700]));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
