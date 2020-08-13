import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial());
  //AuthService Object
  final _auth = AuthService();

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is DoRegisterEvent) {
      //Show Loading Dialog
      yield LoadingState();

      //API result
      var result = await _auth.signUp(event.commerceData);
      if (result['err'] != null) {
        yield ErrorBlocState(error: result['err'], hide: true);
      } else {
        yield RegisterSuccess();
      }
    } else if (event is ValidateEvent) {
      Map data = event.commerceData;
      String error = validate(data);
      if (error != null) {
        yield ErrorBlocState(error: error, hide: false);
      } else {
        //Show Loading Dialog
        yield LoadingState();
        //API result
        var result = await _auth.checkEmail(data['email']);
        if (result['err'] == null) {
          yield EmailValidated();
        } else {
          yield ErrorBlocState(error: result['err'], hide: true);
        }
      }
    }
    yield RegisterInitial();
  }

  String validate(Map data) {
    String error;
    //Verify data
    if (data['email'].length == 0 ||
        data['password'].length == 0 ||
        data['name'].length == 0 ||
        data['category'].length == 0) {
      error = 'You must enter all the fields.';
    } else if (!validateEmail(data['email'])) {
      error = 'Enter an valid email.';
    } else if (data['password'].length < 6) {
      error = 'Enter a password 6+ chars long';
    } else if (data['image'] == null) {
      error = 'Dont Image Selected';
    }
    return error;
  }
}
