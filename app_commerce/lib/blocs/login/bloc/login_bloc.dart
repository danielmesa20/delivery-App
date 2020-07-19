import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is DoLoginEvent) {
      //Loading State
      yield LoadingState();

      //Logic Login
      final _auth = AuthService();

      //Result from API
      dynamic result = await _auth.signIn(event.email, event.password);

      //Verify Api result
      if (result['err'] == null) {
        yield LoggedInBLocState();
      } else {
        yield LoginFailed(error: result['err']);
      }
    } else if (event is ResetPasswordEvent) {
      yield ResetPasswordSuccess();
    }
  }
}
