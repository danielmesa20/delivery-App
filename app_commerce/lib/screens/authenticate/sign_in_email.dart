import 'package:brew_crew/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:brew_crew/blocs/login/bloc/login_bloc.dart';
import 'package:brew_crew/shared/CustomButton.dart';
import 'package:brew_crew/shared/CustomTitle.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:brew_crew/shared/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInWithEmail extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  SignInWithEmail({
    Key key,
    @required GlobalKey<ScaffoldState> scaffoldKey,
  })  : assert(scaffoldKey != null),
        scaffoldKey = scaffoldKey,
        super(key: key);

  @override
  _SignInWithEmailState createState() => _SignInWithEmailState();
}

class _SignInWithEmailState extends State<SignInWithEmail> {
  //Variables
  bool _hidden = true;
  TextEditingController _emailC = new TextEditingController();
  TextEditingController _passwordC = new TextEditingController();

  void validateFields() {
    String error = '';
    if (_emailC.text.length == 0 || _passwordC.text.length == 0) {
      error = 'You must enter all the fields.';
    } else if (!validateEmail(_emailC.text)) {
      error = 'Enter an valid email.';
    }
    if (error.length == 0) {
      BlocProvider.of<LoginBloc>(context).add(DoLoginEvent(
        email: _emailC.text,
        password: _passwordC.text,
      ));
    } else {
      widget.scaffoldKey.currentState.showSnackBar(showSnackBar(
        error,
        Colors.red,
      ));
    }
  }

  // Clean controllers
  void dispose() {
    _emailC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoadingState) {
              //Show Loading  Dialog
              onLoading(context);
            } else if (state is LoggedInBLocState) {
              //Pop Loading Dialog
              Navigator.pop(context);
              //Update AuthenticationBloc State
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
              //changeScreen(context, Home());
            } else if (state is ResetPasswordSuccess) {
              widget.scaffoldKey.currentState.showSnackBar(showSnackBar(
                  'This function has not been implemented',
                  Colors.yellow[700]));
            } else if (state is LoginFailed) {
              //Pop Loading Dialog
              Navigator.pop(context);
              //Show Error message
              widget.scaffoldKey.currentState.showSnackBar(showSnackBar(
                state.error,
                Colors.red,
              ));
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              var width = (constraints.maxWidth / 8);
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: width,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    CustomTitle(
                      size: width * 1.15,
                      text: "SIGN IN WITH EMAIL",
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
                          onPressed: () => setState(() => _hidden = !_hidden),
                        ),
                      ),
                      obscureText: _hidden,
                    ),
                    SizedBox(height: 20.0),
                    CustomButton(
                      backgroundColor: Color.fromRGBO(0, 168, 150, 1),
                      text: "Enter",
                      textColor: Colors.white,
                      actionOnpressed: () {
                        validateFields();
                      },
                    ),
                    CustomButton(
                      backgroundColor: Colors.transparent,
                      text: "I forgot my password",
                      textColor: Colors.white,
                      actionOnpressed: () {
                        if (_emailC.text.isNotEmpty) {
                          BlocProvider.of<LoginBloc>(context)
                              .add(ResetPasswordEvent(
                            email: _emailC.text,
                          ));
                        } else {
                          widget.scaffoldKey.currentState
                              .showSnackBar(showSnackBar(
                            'Please supply a valid email.',
                            Colors.red,
                          ));
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
