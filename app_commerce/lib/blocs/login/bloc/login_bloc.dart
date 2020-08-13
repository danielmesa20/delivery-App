import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());

  //Auth Object
  final _auth = AuthService();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    //Try to Login
    if (event is DoLoginEvent) {
      //Loading State
      yield LoadingState();

      //Result from API
      dynamic result = await _auth.signIn(event.email, event.password);

      //Verify Api result
      if (result['err'] == null) {
        yield LoggedInBLocState();
      } else {
        yield ErrorBlocState(error: result['err'], hide: true);
      }
    } else if (event is ValidatedFields) {
      if (event.email.length == 0 || event.password.length == 0) {
        yield ErrorBlocState(
            error: 'You must enter all the fields.', hide: false);
      } else if (!validateEmail(event.email)) {
        yield ErrorBlocState(error: 'Enter an valid email.', hide: false);
      } else {
        yield ValidatedFieldsSuccess();
      }
    } else if (event is ResetPasswordEvent) {
      yield ResetPasswordSuccess();
    }
    yield LoginInitial();
  }
}
