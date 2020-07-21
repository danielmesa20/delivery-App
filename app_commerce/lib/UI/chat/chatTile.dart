import 'package:brew_crew/models/User.dart';
import 'package:flutter/material.dart';

enum UserOnlineStatus { connecting, online, not_online }

class ChatTile extends StatefulWidget {
  final User user;
  final UserOnlineStatus userOnlineStatus;
  //Constructor
  ChatTile({this.user, this.userOnlineStatus});

  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(widget.user.name),
          Text(
            _getStatusText(),
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white70,
            ),
          )
        ],
      ),
    );
  }

  _getStatusText() {
    if (widget.userOnlineStatus == UserOnlineStatus.online) {
      return "Online";
    } else if (widget.userOnlineStatus == UserOnlineStatus.not_online) {
      return "Not Online";
    }
    return "Connecting..";
  }
}
