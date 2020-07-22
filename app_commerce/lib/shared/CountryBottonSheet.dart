import 'package:flutter/material.dart';

class CountryBottonSheet extends StatefulWidget {
  CountryBottonSheet({Key key}) : super(key: key);

  @override
  _CountryBottonSheetState createState() => _CountryBottonSheetState();
}

class _CountryBottonSheetState extends State<CountryBottonSheet> {
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
          children: [
            SizedBox(height: 10),
            Text(
              'Select Country Location',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.red,
                        child: InkWell(
                          splashColor: Colors.red,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage("assets/flags/argentina.png"),
                          ),
                          onTap: () => Navigator.pop(context, 'Argentina'),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Argentina',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.red,
                        child: InkWell(
                          splashColor: Colors.red,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage("assets/flags/chile.png"),
                          ),
                          onTap: () => Navigator.pop(context, 'Chile'),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Chile',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.red,
                        child: InkWell(
                          splashColor: Colors.red,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage("assets/flags/colombia.png"),
                          ),
                          onTap: () => Navigator.pop(context, 'Colombia'),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Colombia',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.red,
                        child: InkWell(
                          splashColor: Colors.red,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage("assets/flags/ecuador.png"),
                          ),
                          onTap: () => Navigator.pop(context, 'Ecuador'),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Ecuador',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.red,
                        child: InkWell(
                          splashColor: Colors.red,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage("assets/flags/peru.png"),
                          ),
                          onTap: () => Navigator.pop(context, 'Perú'),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Perú',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.red,
                        child: InkWell(
                          splashColor: Colors.red,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage("assets/flags/venezuela.png"),
                          ),
                          onTap: () => Navigator.pop(context, 'Venezuela'),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Venezuela',
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
