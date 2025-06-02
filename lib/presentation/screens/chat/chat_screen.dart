import 'package:flutter/material.dart';
import 'package:matchbox_app/config.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  final String otherUserId;
  final String otherUserName;

  const ChatScreen({super.key, required this.otherUserId, required this.otherUserName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  late String chatId;

  @override
  void initState() {
    super.initState();
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    chatId = Provider.of<ChatProvider>(context, listen: false).getChatId(currentUserId, widget.otherUserId);
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.otherUserName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: chatProvider.streamMessages(chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final messages = snapshot.data!;
                final currentUserId = FirebaseAuth.instance.currentUser!.uid;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg['senderId'] == currentUserId;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? appColors.red : Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(msg['text'] ?? '', style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          _buildMessageInput(chatProvider),
          const Divider(height: 2)
        ],
      ),
    );
  }

  Widget _buildMessageInput(ChatProvider chatProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              cursorColor: appColors.red,
              decoration: const InputDecoration(hintText: 'Type a message...'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              final text = _messageController.text.trim();
              if (text.isNotEmpty) {
                chatProvider.sendMessage(chatId, text);
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
