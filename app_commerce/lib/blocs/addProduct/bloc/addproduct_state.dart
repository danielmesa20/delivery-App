part of 'addproduct_bloc.dart';

@immutable
abstract class AddproductState extends Equatable {
  const AddproductState();
  @override
  List<Object> get props => [];
}

class Loading extends AddproductState {}

class SuccessAdd extends AddproductState {}

class FailedAdd extends AddproductState {
  final String error;
  FailedAdd({@required this.error});
  @override
  List<Object> get props => [error];
}
