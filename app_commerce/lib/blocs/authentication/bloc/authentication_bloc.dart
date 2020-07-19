import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthService _auth;

  AuthenticationBloc({@required AuthService auth})
      : assert(auth != null),
        _auth = auth,
        super(Uninitialized());
        
  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      final bool result = await _auth.isSignedIn();
      if (result) {
        yield Authenticated();
      } else {
        yield Unauthenticated();
      }
    } else if (event is LoggedIn) {
      yield Authenticated();
    } else if (event is LoggedOut) {
      yield Unauthenticated();
      await _auth.signOut();
    }
  }
}
