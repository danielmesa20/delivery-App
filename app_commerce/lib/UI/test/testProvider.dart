import 'package:brew_crew/UI/test/testScreen.dart';
import 'package:brew_crew/Models/Product.dart';
import 'package:brew_crew/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Product>>.value(
      initialData: null,
      value: DatabaseService().streamProducts(),
      child: TestScreen(),
    );
  }
}