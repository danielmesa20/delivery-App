import 'dart:io';
import 'dart:math';
import 'package:brew_crew/shared/Functions.dart';
import 'package:brew_crew/shared/ImageBottonSheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CustomCircleAvatar extends StatefulWidget {
  final String url;
  final Function action;
  final Color color;
  final GlobalKey<ScaffoldState> scaffoldKey;
  CustomCircleAvatar({this.url, this.action, this.color, this.scaffoldKey});
  @override
  _CustomCircleAvatarState createState() => _CustomCircleAvatarState();
}

class _CustomCircleAvatarState extends State<CustomCircleAvatar> {
  //Variables
  File _image;

  //Get photo from gallery
  Future<void> getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        widget.action(_image);
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
        widget.action(_image);
      });
    }
  }

  //Select image option
  void _showAddPanel() async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      elevation: 0.0,
      isDismissible: true,
      builder: (context) {
        return ImageBottonSheet();
      },
    );
    if (result == 0) {
      setState(() => _image = null);
      widget.action(null);
    } else if (result == 1) {
      getImage(ImageSource.gallery);
    } else if (result == 2) {
      getImage(ImageSource.camera);
    } else if (result == 3) {
      if (_image != null) {
        cropImage(_image);
      } else {
        //Show the snackbar with the message
        widget.scaffoldKey.currentState.showSnackBar(showSnackBar(
            'To edit you have to choose a new image', Colors.grey[500]));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (context, constraints) {
          var radius =
              min(constraints.maxHeight / 3.5, constraints.maxWidth / 3.5);
          return CircleAvatar(
            radius: radius,
            backgroundColor: widget.color,
            child: InkWell(
              child: CircleAvatar(
                  radius: radius - 5,
                  backgroundColor: Color.fromRGBO(2, 89, 111, 126),
                  child: widget.url != null
                      ? CachedNetworkImage(
                          color: Color.fromRGBO(2, 128, 144, 1),
                          imageUrl: widget.url,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          ),
                          imageBuilder: (context, image) => CircleAvatar(
                            backgroundColor: Color.fromRGBO(2, 89, 111, 126),
                            backgroundImage: image,
                            radius: radius - 5,
                          ),
                        )
                      : null,
                  backgroundImage: widget.url == null
                      ? _image == null
                          ? AssetImage("assets/imagedontfound.png")
                          : FileImage(_image)
                      : null),
              onTap: () => _showAddPanel(),
            ),
          );
        },
      ),
    );
  }
}
