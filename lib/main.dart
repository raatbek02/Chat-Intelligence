import 'package:ai_chatbot/core/common/onboarding.dart';
import 'package:ai_chatbot/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:ai_chatbot/features/chat/presentation/bloc/theme_bloc.dart';
import 'package:ai_chatbot/features/chat/presentation/bloc/theme_state.dart';
import 'package:ai_chatbot/core/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final chatBloc = ChatBloc();

  runApp(
    MyApp(chatBloc: chatBloc),
  );
}

class MyApp extends StatelessWidget {
  final ChatBloc chatBloc;

  const MyApp({super.key, required this.chatBloc});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
        BlocProvider<ChatBloc>.value(value: chatBloc),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Chat Intelligence',
            theme: lightMode,
            darkTheme: darkMode,
            themeMode: state.themeMode,
            home: const Onboarding(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
