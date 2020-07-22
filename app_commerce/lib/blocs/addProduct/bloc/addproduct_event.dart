part of 'addproduct_bloc.dart';

@immutable
abstract class AddproductEvent extends Equatable {
  const AddproductEvent();

  @override
  List<Object> get props => [];
}

class AddProductEvent extends AddproductEvent {
  final Map data;
  AddProductEvent({@required this.data});

  @override
  List<Object> get props => [data];
}

class ValidateFieldsEvent extends AddproductEvent {
  final Map data;
  ValidateFieldsEvent({@required this.data});

  @override
  List<Object> get props => [data];
}
