import 'package:brew_crew/Data/messages.dart';
import 'package:brew_crew/UI/products/delete_product.dart';
import 'package:brew_crew/UI/products/treding_item.dart';
import 'package:brew_crew/blocs/listProducts/bloc/listproducts_bloc.dart';
import 'package:brew_crew/UI/products/add_product.dart';
import 'package:brew_crew/UI/products/empty_list_products.dart';
import 'package:brew_crew/shared/CustomAlertDialog.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:brew_crew/shared/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListProductsProvider extends StatelessWidget {
  const ListProductsProvider({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)  => ListproductsBloc()..add(LoadProducts()),
      child: ListProductsScreen(),
    );
  }
}

class ListProductsScreen extends StatelessWidget {
  //Variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(2, 128, 144, 1),
      body: SafeArea(
        child: Center(
          child: BlocListener<ListproductsBloc, ListproductsState>(
            listener: (context, state) {
              if (state is FailedState) {
                //Show the snackbar with the err
                _scaffoldKey.currentState
                    .showSnackBar(showSnackBar(state.error, Colors.red));
              } else if (state is FailedDelete) {
                _scaffoldKey.currentState
                    .showSnackBar(showSnackBar(state.error, Colors.red));
                //Reload list of products
                BlocProvider.of<ListproductsBloc>(context).add(LoadProducts());
              } else if (state is SuccessDelete) {
                _scaffoldKey.currentState.showSnackBar(
                    showSnackBar(DELETE_PRODUCT_COMPLETED, Colors.green[700]));
                //Reload list of products
                BlocProvider.of<ListproductsBloc>(context).add(LoadProducts());
              }
            },
            child: BlocBuilder<ListproductsBloc, ListproductsState>(
              builder: (context, state) {
                if (state is LoadingProducts) {
                  return Loading();
                } else if (state is SuccessLoad) {
                  return Container(
                    child: GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(10),
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      controller: ScrollController(keepScrollOffset: false),
                      children: List.generate(
                        state.products.length,
                        (index) {
                          return Dismissible(
                            key: ValueKey(state.products[index]),
                            child: TrendingItem(
                              product: state.products[index],
                              scaffoldKey: _scaffoldKey,
                            ),
                            direction: DismissDirection.endToStart,
                            background: Container(color: Colors.green),
                            secondaryBackground: DeleteProductScreen(),
                            confirmDismiss: (direction) async {
                              final result = await showDialog<int>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return CustomAlertDialog(
                                    text: CONFIRM_DELETE_PRODUCT +
                                        '${state.products[index].name}',
                                  );
                                },
                              );
                              if (result == 0) {
                                return false;
                              } else {
                                BlocProvider.of<ListproductsBloc>(context).add(
                                    DeleteProduct(
                                        id: state.products[index].id));
                                return true;
                              }
                            },
                          );
                        },
                      ),
                    ),
                  );
                } else if (state is FailedState || state is EmptyList) {
                  return EmptyListProducts();
                }
                return Container();
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(2, 89, 111, 10),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductProvider(),
            ),
          );
          if (result != null) {
            //Show Add message completed
            _scaffoldKey.currentState
                .showSnackBar(showSnackBar(result, Colors.greenAccent[700]));
            //Reload list of products
            BlocProvider.of<ListproductsBloc>(context).add(LoadProducts());
          }
        },
      ),
    );
  }
}
