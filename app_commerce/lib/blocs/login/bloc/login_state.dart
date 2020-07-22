part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object> get props => [];
}

//Initial State
class LoginInitial extends LoginState {}

//Loading state
class LoadingState extends LoginState {}

//Login Success
class LoggedInBLocState extends LoginState {}

//Reset password success
class ResetPasswordSuccess extends LoginState {}

//Validate Fields Success
class ValidatedFieldsSuccess extends LoginState {}

//Change password visibility
class ChangePasswordVisibility extends LoginState{
  final bool hide;
  ChangePasswordVisibility({ @required this.hide});
  @override
  List<Object> get props => [hide];
}

//Error State
class ErrorBlocState extends LoginState {
  final String error;
  final bool hide;
  ErrorBlocState({
    @required this.error,
    @required this.hide,
  });
  @override
  List<Object> get props => [error, hide];
}
