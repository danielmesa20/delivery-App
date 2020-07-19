part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();
}

//Validate fields
class ValidateEvent extends RegisterEvent {
  final Map commerceData;

  ValidateEvent({this.commerceData});
  @override
  List<Object> get props => [commerceData];
}

//Try to Register Commerce
class DoRegisterEvent extends RegisterEvent {
  final Map commerceData;

  DoRegisterEvent({this.commerceData});
  @override
  List<Object> get props => [commerceData];
}

//Change options
class ChangeListOptionsEvent extends RegisterEvent {
  final String country;

  ChangeListOptionsEvent({this.country});
  @override
  List<Object> get props => [country];
}
