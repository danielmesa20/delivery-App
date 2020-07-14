import 'package:flutter/material.dart';

class CustomImageSource extends StatefulWidget {
  CustomImageSource({Key key}) : super(key: key);

  @override
  _CustomImageSourceState createState() => _CustomImageSourceState();
}

class _CustomImageSourceState extends State<CustomImageSource> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(2, 128, 144, 1),
      contentPadding: EdgeInsets.all(0),
      content: LayoutBuilder(builder: (context, constraints) {
        var width = constraints.maxWidth / 2;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: width,
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 168, 150, 1),
                border: Border.all(),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    color: Colors.white,
                    iconSize: 30.0,
                    onPressed: () {
                      Navigator.pop(context, 0);
                    },
                  ),
                  Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              width: width,
              decoration: BoxDecoration(
                color:  Color.fromRGBO(2, 89, 111, 126),
                border: Border.all(),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.photo_size_select_actual),
                    color: Colors.white,
                    iconSize: 30.0,
                    onPressed: () {
                      Navigator.pop(context, 1);
                    },
                  ),
                  Text(
                    'Gallery',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
