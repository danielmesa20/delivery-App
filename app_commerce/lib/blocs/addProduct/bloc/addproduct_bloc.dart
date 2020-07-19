import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:brew_crew/services/database.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'addproduct_event.dart';
part 'addproduct_state.dart';

class AddproductBloc extends Bloc<AddproductEvent, AddproductState> {
  //Database object
  final _database = DatabaseService();
  AddproductBloc() : super(Loading());

  @override
  Stream<AddproductState> mapEventToState(
    AddproductEvent event,
  ) async* {
    if (event is AddProduct) {
      //Show Loading Alert dialog
      yield Loading();

      //API result
      var result = await _database.addProduct(event.data);

      if (result['err'] != null) {
        //Show the snackbar with the err
        yield FailedAdd(error: result['err']);
      } else {
        yield SuccessAdd();
      }
    }
  }
}
