part of 'addproduct_bloc.dart';

@immutable
abstract class AddproductEvent extends Equatable {
  const AddproductEvent();

  @override
  List<Object> get props => [];
}

class AddProduct extends AddproductEvent {
  final Map data;
  AddProduct({ @required this.data});

  @override
  List<Object> get props => [data];
}
