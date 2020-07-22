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
  AddproductBloc() : super(InitialState());

  @override
  Stream<AddproductState> mapEventToState(
    AddproductEvent event,
  ) async* {
    if (event is AddProductEvent) {
      //Show Loading Alert dialog
      yield LoadingState();
      //API result
      var result = await _database.addProduct(event.data);
      if (result['err'] != null) {
        //Show the snackbar with the err
        yield AddProductErrorState(error: result['err'], hide: true);
      } else {
        yield SuccessAddState();
      }
    } else if (event is ValidateFieldsEvent) {
      String error = validate(event.data);
      if (error != null) {
        yield AddProductErrorState(error: error, hide: false);
      } else {
        yield SuccesValidateState();
      }
    }
    yield InitialState();
  }

  String validate(Map data) {
    String error;
    //Verify data
    if (data['name'].length == 0 ||
        data['price'].length == 0 ||
        data['description'].length == 0) {
      error = 'You must enter all the fields.';
    } else if (double.parse(data['price']) <= 0) {
      error = 'Enter a price greater than 0.';
    } else if (data['image'] == null) {
      error = 'Dont Image Selected';
    }
    return error;
  }
}
