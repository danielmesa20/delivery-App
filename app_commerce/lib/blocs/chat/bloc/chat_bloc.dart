import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:brew_crew/models/Chat.dart';
import 'package:brew_crew/services/database.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  //Database object
  final _database = DatabaseService();
  ChatBloc() : super(LoadingChats());

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is LoadChats) {
      //Show Circular Progress Indicator
      LoadingChats();
      //Recived result Api
      dynamic result = await _database.getChats();
      if (result['err'] == null) {
        final List<dynamic> _chats =
            result['chats'].map((model) => Chat.fromJson(model)).toList();
        if (_chats.length > 0) {
          yield SuccessLoad(chats: _chats);
        } else {
          yield EmptyList();
        }
      }
    }
  }
}
