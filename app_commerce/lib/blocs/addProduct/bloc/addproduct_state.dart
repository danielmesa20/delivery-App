part of 'addproduct_bloc.dart';

@immutable
abstract class AddproductState extends Equatable {
  const AddproductState();
  @override
  List<Object> get props => [];
}

class InitialState extends AddproductState {}

class LoadingState extends AddproductState {}

class SuccessAddState extends AddproductState {}

class SuccesValidateState extends AddproductState {}

class AddProductErrorState extends AddproductState {
  final String error;
  final bool hide;

  AddProductErrorState({@required this.error, @required this.hide});
  @override
  List<Object> get props => [error, hide];
}
