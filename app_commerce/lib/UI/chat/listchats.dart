import 'dart:async';

import 'package:brew_crew/UI/chat/EmptyListChats.dart';
import 'package:brew_crew/UI/chat/chatTile.dart';
import 'package:brew_crew/blocs/chat/bloc/chat_bloc.dart';
import 'package:brew_crew/shared/Functions.dart';
import 'package:brew_crew/shared/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListChat extends StatefulWidget {
  ListChat({Key key}) : super(key: key);

  @override
  _ListChatState createState() => _ListChatState();
}



class _ListChatState extends State<ListChat> {
  //Variables
  final _scaffoldKey = GlobalKey<ScaffoldState>();

 @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 15), (_) => _initializeTimer());
  }

  void _initializeTimer() {
    print("d");
    BlocProvider.of<ChatBloc>(context).add(LoadChats());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(2, 128, 144, 1),
      body: SafeArea(
        child: Center(
          child: BlocListener<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state is FailedState) {
                //Show the snackbar with the err
                _scaffoldKey.currentState
                    .showSnackBar(showSnackBar(state.error, Colors.red));
              }
            },
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is LoadingChats) {
                  return Loading();
                } else if (state is SuccessLoad) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5, vertical: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.chats.length,
                            itemBuilder: (context, index) {
                              return ChatTile(
                                user: state.chats[index],
                               
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is FailedState || state is EmptyList) {
                  return EmptyListChats();
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
