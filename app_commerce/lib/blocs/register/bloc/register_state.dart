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

//Register failed
class RegisterFailed extends RegisterState {
  final String error;
  RegisterFailed({@required this.error});
  @override
  List<Object> get props => [error];
}

//ChangeList
class ChangeListOptinonsState extends RegisterState {
  final List<String> options;
  ChangeListOptinonsState({@required this.options});
  @override
  List<Object> get props => [options];
}

//Error
class ErrorBlocState extends RegisterState {
  final String error;
  ErrorBlocState({@required this.error});
  @override
  List<Object> get props => [error];
}

