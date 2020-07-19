import 'package:brew_crew/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:brew_crew/screens/authenticate/tab_auth.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //AuthService Instance
  final AuthService auth = AuthService();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(
        BlocProvider(
          create: (context) =>
              AuthenticationBloc(auth: auth)..add(AppStarted()),
          child: MyApp(),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  // Root Application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Uninitialized) {
            return SplashScreen();
          } else if (state is Authenticated) {
            return Home();
          } else if (state is Unauthenticated) {
            return TabAuth();
          }
          return Container();
        },
      ),
    );
  }
}
