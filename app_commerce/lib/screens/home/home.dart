import 'package:brew_crew/screens/authenticate/tab_auth.dart';
import 'package:brew_crew/screens/products/add_product.dart';
import 'package:brew_crew/screens/products/image_capture.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _auth = AuthService();
  //Current Screen
  int _selectedPage = 0;
  //Screen options
  final List<Widget> _pageOptions = <Widget>[
    AddProduct(),
    ImageCapture(),
    Home(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text("Delivery App Alpha"),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<int>(
              padding: EdgeInsets.all(8.0),
              offset: Offset(0, 100),
              itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 1,
                      child: Text(
                        "Logout",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
              onSelected: (value) async {
                await _auth.signOut();
                changeScreen(context, TabAuth());
              }),
        ],
      ),
      body: _pageOptions[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.white,
        fixedColor: Colors.amberAccent,
        backgroundColor: Colors.blue[700],
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
            icon: Icon(Icons.zoom_out),
            title: Text('My data'),
          ),
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
