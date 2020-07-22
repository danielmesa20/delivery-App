import 'package:brew_crew/blocs/login/bloc/login_bloc.dart';
import 'package:brew_crew/blocs/register/bloc/register_bloc.dart';
import 'package:brew_crew/UI/authenticate/register.dart';
import 'package:brew_crew/UI/authenticate/sign_in_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TabAuth extends StatelessWidget {
  //Variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc()),
        BlocProvider(create: (_) => RegisterBloc())
      ],
      child: SafeArea(
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
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromRGBO(2, 128, 144, 1),
                    Color.fromRGBO(0, 168, 150, 10),
                  ],
                ),
                borderRadius: BorderRadius.circular(5),
                color: Color.fromRGBO(2, 128, 144, 1),
              ),
              tabs: [
                Tab(text: "SignIn"),
                Tab(text: "SignUp"),
              ],
            ),
            body: TabBarView(
              children: [
                SignInWithEmail(scaffoldKey: _scaffoldKey),
                Register(scaffoldKey: _scaffoldKey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
