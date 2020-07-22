part of 'listproducts_bloc.dart';

@immutable
abstract class ListproductsState extends Equatable {
  const ListproductsState();
  @override
  List<Object> get props => [];
}

//Initial state
class InitialState extends ListproductsState{}

// Wait Loading 
class LoadingProducts extends ListproductsState {}

//Dont products
class EmptyList extends ListproductsState {}

// Complete get products from API
class SuccessLoad extends ListproductsState {
  final List<dynamic> products;
  SuccessLoad({@required this.products});
  @override
  List<Object> get props => [products];
}

// Error state
class FailedState extends ListproductsState {
  final String error;
  FailedState({@required this.error});
  @override
  List<Object> get props => [error];
}

// Complete delete product from API
class SuccessDelete extends ListproductsState {}

// Complete delete product from API
class FailedDelete extends ListproductsState {
  final String error;
  FailedDelete({@required this.error});
  @override
  List<Object> get props => [error];
}
