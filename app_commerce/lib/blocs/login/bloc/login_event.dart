part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class DoLoginEvent extends LoginEvent {
  final String email;
  final String password;

  DoLoginEvent({ @required this.email,  @required this.password});

  @override
  List<Object> get props => [email, password];
}

class ResetPasswordEvent extends LoginEvent {
  final String email;

  ResetPasswordEvent({ @required this.email});

  @override
  List<Object> get props => [email];
}
