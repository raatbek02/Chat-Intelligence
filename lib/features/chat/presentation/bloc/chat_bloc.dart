import 'package:ai_chatbot/features/chat/domain/entities/message.dart';
import 'package:ai_chatbot/features/chat/presentation/bloc/chat_event.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
  }

  void _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    final messages = List<Message>.from(state.messages)
      ..add(Message(text: event.message, isUser: true));
    emit(ChatLoading(messages: messages));

    try {
      final model = GenerativeModel(
        model: 'gemini-pro',
        // apiKey: dotenv.env['GOOGLE_API_KEY']!,
          apiKey: "AIzaSyBNYyo0uRYBeINFz3aCb3h1mw8Rtzu4bCE",

      );
      final content = [Content.text(event.message)];
      final response = await model.generateContent(content);

      final newMessages = List<Message>.from(messages)
        ..add(Message(text: response.text!, isUser: false));
      emit(ChatLoaded(messages: newMessages));
    } catch (e) {
      print("Error: $e");
      emit(ChatError(messages: messages, error: e.toString()));
    }
  }
}

