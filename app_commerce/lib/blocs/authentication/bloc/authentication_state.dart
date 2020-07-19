part of 'authentication_bloc.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  const AuthenticationState();
  @override
  List<Object> get props => [];
}

// Uninitialized
class Uninitialized extends AuthenticationState {}

// Authenticated
class Authenticated extends AuthenticationState {}

// Unauthenticated
class Unauthenticated extends AuthenticationState {}
