import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final String text;
  CustomAlertDialog({this.text});
  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'CONFIRM',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color.fromRGBO(2, 128, 144, 1),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(widget.text,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.justify),
            SizedBox(height: 20.0),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('No'),
          color: Colors.red,
          onPressed: () {
            Navigator.pop(context, 0);
          },
        ),
        FlatButton(
          child: Text(
            'Si',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.greenAccent,
          onPressed: () {
            Navigator.pop(context, 1);
          },
        ),
      ],
    );
  }
}
