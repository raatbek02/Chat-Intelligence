part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  final List<Message> messages;

  const ChatState({required this.messages});

  @override
  List<Object> get props => [messages];
}

class ChatInitial extends ChatState {
  ChatInitial() : super(messages: []);
}

class ChatLoading extends ChatState {
  const ChatLoading({required super.messages});
}

class ChatLoaded extends ChatState {
  const ChatLoaded({required super.messages});
}

class ChatError extends ChatState {
  final String error;

  const ChatError({required super.messages, required this.error});

  @override
  List<Object> get props => [messages, error];
}
