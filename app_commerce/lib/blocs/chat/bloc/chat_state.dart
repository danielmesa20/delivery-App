part of 'chat_bloc.dart';

@immutable
abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object> get props => [];
}

// Loading chats from API
class LoadingChats extends ChatState {}

//Dont products
class EmptyList extends ChatState {}

// Complete get products from API
class SuccessLoad extends ChatState {
  final List<dynamic> chats;
  SuccessLoad({@required this.chats});
  @override
  List<Object> get props => [chats];
}

// Error state
class FailedState extends ChatState {
  final String error;
  FailedState({@required this.error});
  @override
  List<Object> get props => [error];
}
