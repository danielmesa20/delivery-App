import 'dart:io';
import 'dart:math';
import 'package:brew_crew/shared/Functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  //Variables
  File _image;
  final picker = ImagePicker();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> cropImage(File image) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        maxWidth: 1080,
        maxHeight: 1080,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Edit Image Product',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    if (croppedImage != null) {
      setState(() {
        _image = croppedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () => _image != null
                          ? {Navigator.pop(context, _image)}
                          : _scaffoldKey.currentState.showSnackBar(showSnackBar(
                              'Dont Image Selected.', Colors.yellow[700])),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.send),
                          Text("Enter")
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () => _image != null
                          ? cropImage(_image)
                          : _scaffoldKey.currentState.showSnackBar(showSnackBar(
                              'Select an image first.', Colors.yellow[700])),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.edit),
                          Text("Edit image")
                        ],
                      ),
                    ),
                    FlatButton(
                      onPressed: () => setState(() => _image = null),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.delete),
                          Text("Delete image")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                heightFactor: 2.0,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    var radius = min(
                        constraints.maxHeight / 3, constraints.maxWidth / 3);
                    return CircleAvatar(
                      radius: radius,
                      child: CircleAvatar(
                        radius: radius - 5,
                        backgroundImage: _image == null
                            ? AssetImage("assets/imagedontfound.png")
                            : FileImage(_image),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        children: [
          SpeedDialChild(
              child: Icon(Icons.camera_alt),
              backgroundColor: Colors.green[800],
              label: 'Camera',
              onTap: () => getImage(ImageSource.camera)),
          SpeedDialChild(
              child: Icon(Icons.photo),
              backgroundColor: Colors.green,
              label: 'Gallery',
              onTap: () => getImage(ImageSource.gallery)),
        ],
      ),
    );
  }
}
