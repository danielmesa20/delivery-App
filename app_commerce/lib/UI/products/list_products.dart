import 'package:brew_crew/blocs/listProducts/bloc/listproducts_bloc.dart';
import 'package:brew_crew/UI/products/add_product.dart';
import 'package:brew_crew/UI/products/empty_list_products.dart';
import 'package:brew_crew/UI/products/product_tile.dart';
import 'package:brew_crew/shared/CustomAlertDialog.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:brew_crew/shared/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListProducts extends StatefulWidget {
  @override
  _ListProductsState createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
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
                _scaffoldKey.currentState.showSnackBar(showSnackBar(
                    'Delete Product Completed.', Colors.green[700]));
                //Reload list of products
                BlocProvider.of<ListproductsBloc>(context).add(LoadProducts());
              } 
            },
            child: BlocBuilder<ListproductsBloc, ListproductsState>(
              builder: (context, state) {
                if (state is LoadingProducts) {
                  return Loading();
                } else if (state is SuccessLoad) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.products.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: ValueKey(state.products[index]),
                                child: ProductTile(
                                  product: state.products[index],
                                  scaffoldKey: _scaffoldKey,
                                ),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  color: Colors.green,
                                ),
                                secondaryBackground: Container(
                                  color: Colors.red,
                                  child: Align(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          " Delete",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        SizedBox(width: 20),
                                      ],
                                    ),
                                    alignment: Alignment.centerRight,
                                  ),
                                ),
                                confirmDismiss: (direction) async {
                                  final result = await showDialog<int>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return CustomAlertDialog(
                                          text: 'Are you sure you want to delete' +
                                              ' the product: ${state.products[index].name}');
                                    },
                                  );
                                  if (result == 0) {
                                    return false;
                                  } else {
                                    BlocProvider.of<ListproductsBloc>(context)
                                        .add(DeleteProduct(id: 'zxfsdfs'));
                                    return true;
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
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
        backgroundColor: Color.fromRGBO(240, 243, 189, 10),
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductScreen(),
            ),
          );
          if (result != null) {
            //Show Add message completed
            _scaffoldKey.currentState
                .showSnackBar(showSnackBar(result, Colors.green[500]));
            //Reload list of products
            BlocProvider.of<ListproductsBloc>(context).add(LoadProducts());
          }
        },
      ),
    );
  }
}
