import 'package:brew_crew/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:brew_crew/blocs/listProducts/bloc/listproducts_bloc.dart';
import 'package:brew_crew/screens/products/add_product.dart';
import 'package:brew_crew/screens/products/list_products.dart';
import 'package:brew_crew/screens/profile/profileData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //Current Screen
  int _selectedPage = 0;
  //Screen options
  final List<Widget> _pageOptions = <Widget>[
    ListProducts(),
    AddProduct(),
    ProfileData(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery App Alpha"),
        backgroundColor: Color.fromRGBO(0, 168, 150, 1),
        elevation: 0.0,
        actions: <Widget>[
          PopupMenuButton<int>(
            color: Color.fromRGBO(0, 168, 150, 1),
            offset: Offset(0, 100),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text(
                  "Logout",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.0,
                    letterSpacing: 1.25,
                  ),
                ),
              ),
            ],
            onSelected: (value) async {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ListproductsBloc()..add(LoadProducts()),
          ),
          /*BlocProvider(
            create: (context) => AddproductBloc(),
          ),*/
        ],
        child: _pageOptions[_selectedPage],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white,
        fixedColor: Color.fromRGBO(2, 89, 111, 10),
        backgroundColor: Color.fromRGBO(0, 168, 150, 1),
        currentIndex: _selectedPage,
        onTap: (index) => setState(() => _selectedPage = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('My Products'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Orders'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('My data'),
          ),
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
