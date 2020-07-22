import 'package:flutter/material.dart';

class ImageBottonSheet extends StatefulWidget {
  ImageBottonSheet({Key key}) : super(key: key);

  @override
  _ImageBottonSheetState createState() => _ImageBottonSheetState();
}

class _ImageBottonSheetState extends State<ImageBottonSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        color: Color.fromRGBO(2, 128, 144, 1),
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              'Select option',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.red,
                        child: InkWell(
                          splashColor: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context, 0);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Delete',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.purple,
                        child: InkWell(
                          splashColor: Colors.red,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.image,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context, 1);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Gallery',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.green,
                        child: InkWell(
                          splashColor: Colors.redAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context, 2);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Camera',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue,
                        child: InkWell(
                          splashColor: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context, 3);
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Edit',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
