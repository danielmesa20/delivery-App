part of 'listproducts_bloc.dart';

@immutable
abstract class ListproductsEvent extends Equatable {
  const ListproductsEvent();

  @override
  List<Object> get props => [];
}

//Load products commerce from Api
class LoadProducts extends ListproductsEvent {}

//Delete One Commerce Product 
class DeleteProduct extends ListproductsEvent {
  final String id;
  DeleteProduct({@required this.id});

  @override
  List<Object> get props => [id];
}
