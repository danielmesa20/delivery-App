part of 'login_bloc.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object> get props => [];
}

//Loading state
class LoadingState extends LoginState {
  @override
  List<Object> get props => [];
}

//Login Success
class LoggedInBLocState extends LoginState {
  @override
  List<Object> get props => [];
}

//Login Failed
class LoginFailed extends LoginState {
  final String error;
  LoginFailed({@required this.error});
  @override
  List<Object> get props => [error];
}

//Reset password success
class ResetPasswordSuccess extends LoginState {
  @override
  List<Object> get props => [];
}

//Error
class ErrorBlocState extends LoginState {
  final String error;
  ErrorBlocState({@required this.error});
  @override
  List<Object> get props => [error];
}
