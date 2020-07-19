part of 'register_bloc.dart';

@immutable
abstract class RegisterState extends Equatable {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  @override
  List<Object> get props => [];
}

//Loading
class LoadingState extends RegisterState {
  @override
  List<Object> get props => [];
}

//Validate fields success
class ValidateFieldsCompleted extends RegisterState {
  @override
  List<Object> get props => [];
}

//Register success
class RegisterSuccess extends RegisterState {
  @override
  List<Object> get props => [];
}

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

class ErrorBlocState extends RegisterState {
  final String error;
  ErrorBlocState({@required this.error});
  @override
  List<Object> get props => [error];
}

//Register success
class CleanState extends RegisterState {
  @override
  List<Object> get props => [];
}

