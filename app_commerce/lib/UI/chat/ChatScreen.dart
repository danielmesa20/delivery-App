import 'dart:async';

import 'package:brew_crew/UI/chat/Global.dart';
import 'package:brew_crew/UI/chat/chatTile.dart';
import 'package:brew_crew/models/ChatMessage.dart';
import 'package:brew_crew/models/User.dart';
import 'package:flutter/material.dart';

import 'SocketUtils.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //Variables
  List<ChatMessage> _chatMessages;
  User _toChatUser;
  UserOnlineStatus _userOnlineStatus;
  TextEditingController _chatTfController;
  ScrollController _chatLVController;

  @override
  void setState(fn) {
    if(mounted)
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _userOnlineStatus = UserOnlineStatus.connecting;
    _chatLVController = ScrollController(initialScrollOffset: 0.0);
    _chatTfController = TextEditingController();
    _toChatUser = G.toChatUser;
    _chatMessages = List();
     _initSocketListeners();
     _checkOnline();
  }

   _checkOnline() async {
    ChatMessage chatMessageModel = ChatMessage(
      to: G.toChatUser.id,
      from: G.loggedInUser.id,
    );
    G.socketUtils.checkOnline(chatMessageModel);
  }

   _initSocketListeners() async {
    G.socketUtils.setOnUserConnectionStatusListener(onUserConnectionStatus);
    G.socketUtils.setOnChatMessageReceivedListener(onChatMessageReceived);
    G.socketUtils.setOnMessageBackFromServer(onMessageBackFromServer);
  }

  onChatMessageReceived(data) {
    print('onChatMessageReceived $data');
    if (null == data || data.toString().isEmpty) {
      return;
    }
    ChatMessage chatMessageModel = ChatMessage.fromJson(data);
    chatMessageModel.isFromMe = false;
    bool online = chatMessageModel.toUserOnlineStatus;
    _updateToUserOnlineStatusInUI(online);
    processMessage(chatMessageModel);
  }

  onMessageBackFromServer(data) {
    ChatMessage chatMessageModel = ChatMessage.fromJson(data);
    bool online = chatMessageModel.toUserOnlineStatus;
    print('onMessageBackFromServer $data');
    if (!online) {
      print('User not connected');
    }
  }

   processMessage(ChatMessage chatMessageModel) {
    _addMessage(0, chatMessageModel, false);
  }

  _addMessage(id, ChatMessage chatMessageModel, fromMe) async {
    print('Adding Message to UI ${chatMessageModel.message}');
    setState(() {
      _chatMessages.add(chatMessageModel);
    });
    print('Total Messages: ${_chatMessages.length}');
    _chatListScrollToBottom();
  }

   /// Scroll the Chat List when it goes to bottom
  _chatListScrollToBottom() {
    Timer(Duration(milliseconds: 100), () {
      if (_chatLVController.hasClients) {
        _chatLVController.animateTo(
          _chatLVController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.decelerate,
        );
      }
    });
  }

  _updateToUserOnlineStatusInUI(online) {
    setState(() {
      _userOnlineStatus =
          online ? UserOnlineStatus.online : UserOnlineStatus.not_online;
    });
  }

  onUserConnectionStatus(data) {
    ChatMessage chatMessageModel = ChatMessage.fromJson(data);
    bool online = chatMessageModel.toUserOnlineStatus;
    _updateToUserOnlineStatusInUI(online);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ChatTile(
          user: _toChatUser,
          userOnlineStatus: _userOnlineStatus,
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  ChatMessage chatMessage = _chatMessages[index];
                  return Text(chatMessage.message);
                },
              ),
            ),
            _bottomChatArea(),
          ],
        ),
      ),
    );
  }

  _bottomChatArea() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          _chatTextArea(),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendButtonTap();
            },
          )
        ],
      ),
    );
  }

  _sendButtonTap() async {
    if (_chatTfController.text.isEmpty) {
      return;
    }
    ChatMessage chatMessageModel = ChatMessage(
      chatId: 0,
      to: _toChatUser.id,
      from: G.loggedInUser.id,
      toUserOnlineStatus: false,
      message: _chatTfController.text,
      chatType: SocketUtils.SINGLE_CHAT,
      isFromMe: true
    );
    //_addMessage(0, chatMessageModel, _isFromMe(G.loggedInUser));
    //_clearMessage();
    G.socketUtils.sendSingleChatMessage(chatMessageModel, _toChatUser);
  }

  _chatTextArea() {
    return Expanded(
      child: TextField(
        controller: _chatTfController,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(10.0),
            hintText: 'Type message'),
      ),
    );
  }

}
