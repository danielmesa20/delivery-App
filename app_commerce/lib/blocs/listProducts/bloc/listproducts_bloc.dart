import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:brew_crew/models/Product.dart';
import 'package:brew_crew/services/database.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'listproducts_event.dart';
part 'listproducts_state.dart';

class ListproductsBloc extends Bloc<ListproductsEvent, ListproductsState> {
  //Database object
  final _database = DatabaseService();
  ListproductsBloc() : super(LoadingProducts());

  @override
  Stream<ListproductsState> mapEventToState(
    ListproductsEvent event,
  ) async* {
    if (event is LoadProducts) {
      //Show Circular Progress Indicator
      LoadingProducts();
      //Recived result Api
      dynamic result = await _database.getProducts();
      if (result['err'] == null) {
        final List<dynamic> _products =
            result['products'].map((model) => Product.fromJson(model)).toList();
        if (_products.length > 0) {
          yield SuccessLoad(products: _products);
        } else {
          yield EmptyList();
        }
      } else {
        yield FailedState(error: result['err']);
      }
    } else if (event is DeleteProduct) {
      //Show Circular Progress Indicator
      yield LoadingProducts();

      //Recived result Api
      dynamic result = await _database.deleteProduct(event.id);

      if (result['err'] == null) {
        yield SuccessDelete();
      } else {
        yield FailedDelete(error: result['err']);
      }
    }
  }
}
