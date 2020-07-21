import 'package:brew_crew/blocs/chat/bloc/chat_bloc.dart';
import 'package:brew_crew/shared/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmptyListChats extends StatelessWidget {
  const EmptyListChats({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromRGBO(2, 128, 144, 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "There are no chats.",
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 10),
          CustomButton(
            actionOnpressed: () {
              //Reload list of products
              BlocProvider.of<ChatBloc>(context).add(LoadChats());
            },
            text: 'Reload',
            backgroundColor: Color.fromRGBO(240, 243, 189, 10),
            textColor: Colors.black,
          ),
        ],
      ),
    );
  }
}