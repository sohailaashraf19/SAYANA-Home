import 'package:flutter/material.dart';
import 'package:my_house_design/presentation/views/home_view.dart';
import 'package:my_house_design/presentation/widgets/bottom_chat_field.dart';
import 'package:my_house_design/presentation/widgets/chat_messages.dart';
import 'package:my_house_design/presentation/widgets/chat_provider.dart';
import 'package:my_house_design/presentation/widgets/color.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom(){
    WidgetsBinding.instance.addPostFrameCallback((_){
      if(_scrollController.hasClients && _scrollController.position.maxScrollExtent > 0.0) {
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
   return Consumer<ChatProvider>(
    builder: (context, ChatProvider, child) {
      if(ChatProvider.inChatMessages.isNotEmpty) {
        _scrollToBottom();
      }
      ChatProvider.addListener((){
        if(ChatProvider.inChatMessages.isNotEmpty) {
          _scrollToBottom();
        }
      });

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: const Color(0xFF003664),
          title: const Text('BeeTee', style: TextStyle(color: Colors.white)),
          leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeView()),
            );
          },
        ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ChatProvider.inChatMessages.isEmpty
                      ? const Center(
                        child: Text('No messages yet'),
                        )
                      : ChatMessages(scrollController: _scrollController, chatProvider: ChatProvider,),
                ),

                BottomChatField(
                  chatProvider: ChatProvider,)  
              ],
            ),
          ),
        ),
      );
    },
   );
  }
}

