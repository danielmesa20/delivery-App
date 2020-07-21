import 'package:brew_crew/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:brew_crew/UI/authenticate/tab_auth.dart';
import 'package:brew_crew/UI/home/home.dart';
import 'package:brew_crew/shared/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(
        BlocProvider(
          create: (context) => AuthenticationBloc()..add(AppStarted()),
          child: RootApp(),
        ),
      );
    },
  );
}

class RootApp extends StatelessWidget {
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
