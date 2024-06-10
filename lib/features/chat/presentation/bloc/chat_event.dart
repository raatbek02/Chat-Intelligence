import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String message;

  SendMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}
