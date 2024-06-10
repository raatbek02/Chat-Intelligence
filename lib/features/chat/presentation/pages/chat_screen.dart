import 'package:ai_chatbot/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:ai_chatbot/features/chat/presentation/bloc/chat_event.dart';
import 'package:ai_chatbot/features/chat/presentation/bloc/theme_bloc.dart';
import 'package:ai_chatbot/features/chat/presentation/bloc/theme_event.dart';
import 'package:ai_chatbot/features/chat/presentation/bloc/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  MyHomePage({super.key});

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Image.asset('assets/ai_robot.png'),
                ),
                const SizedBox(width: 10),
                Text(
                  'Chat Intelligence',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            BlocBuilder<ThemeBloc, ThemeState>(
              buildWhen: (previous, current) =>
                  previous.themeMode != current.themeMode,
              builder: (context, state) {
                return GestureDetector(
                  child: Icon(
                    state.themeMode == ThemeMode.dark
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: state.themeMode == ThemeMode.dark
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () =>
                      context.read<ThemeBloc>().add(ToggleThemeEvent()),
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listenWhen: (previous, current) =>
                  previous.messages.length != current.messages.length,
              listener: (context, state) => _scrollToBottom(),
              builder: (context, state) {
                if (state is ChatInitial && state.messages.isEmpty) {
                  return Center(
                    child: Text(
                      'Начните беседу😊!',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                } else if (state is ChatError) {
                  return Center(
                      child: Text('Error: ${state.error}. Try again. '));
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: state.messages.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        return Align(
                          alignment: message.isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: message.isUser
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.secondary,
                              borderRadius: message.isUser
                                  ? const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(20),
                                    )
                                  : const BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                    ),
                            ),
                            child: Text(
                              message.text,
                              style: message.isUser
                                  ? Theme.of(context).textTheme.bodyMedium
                                  : Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                bottom: 32, top: 16.0, left: 16.0, right: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      style: Theme.of(context).textTheme.titleSmall,
                      decoration: InputDecoration(
                        hintText: 'Enter your message',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    return GestureDetector(
                      child: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.primary,
                        size: 30,
                      ),
                      onTap: () {
                        if (_controller.text.isNotEmpty) {
                          context
                              .read<ChatBloc>()
                              .add(SendMessageEvent(_controller.text));
                          _controller.clear();
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
