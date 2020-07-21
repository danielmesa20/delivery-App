import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:brew_crew/Data/select_data.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is DoRegisterEvent) {
      //Show Loading Dialog
      yield LoadingState();
      Map data = event.commerceData;
      final _auth = AuthService();
      //API result
      var result = await _auth.signUp(data);
      if (result['err'] != null) {
        yield RegisterFailed(error: result['err']);
      } else {
        yield RegisterSuccess();
      }
    } else if (event is ValidateEvent) {
      Map data = event.commerceData;
      String error = validate(data);
      if (error != null) {
        yield ErrorBlocState(error: error);
      } else {
        yield ValidateFieldsCompleted();
      }
    } else if (event is ChangeListOptionsEvent) {
      if (event.country == 'Venezuela') {
        yield ChangeListOptinonsState(
          options: listStatesVenezuela,
        );
      } else {
        yield ChangeListOptinonsState(
          options: listStatesColombia,
        );
      }
    } else if (event is ResetState) {
      yield RegisterInitial();
    }
  }

  String validate(Map data) {
    String error;
    //Verify data
    if (data['email'].length == 0 ||
        data['password'].length == 0 ||
        data['name'].length == 0 ||
        data['category'].length == 0 ||
        data['country'].length == 0 ||
        data['state'].length == 0) {
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
