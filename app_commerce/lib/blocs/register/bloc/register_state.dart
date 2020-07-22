part of 'register_bloc.dart';

@immutable
abstract class RegisterState extends Equatable {
  const RegisterState();
  @override
  List<Object> get props => [];
}

//Initial state
class RegisterInitial extends RegisterState {}

//Loading
class LoadingState extends RegisterState {}

//Validate fields success
class ValidateFieldsCompleted extends RegisterState {}

//Register success
class RegisterSuccess extends RegisterState {}

class EmailValidated extends RegisterState {}

//Error
class ErrorBlocState extends RegisterState {
  final String error;
  final bool hide;
  ErrorBlocState({@required this.error, @required this.hide});
  @override
  List<Object> get props => [error, hide];
}
