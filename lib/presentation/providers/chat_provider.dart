import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatProvider extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> messages = [];
  bool isTyping = false;

  Stream<List<Map<String, dynamic>>> streamMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> sendMessage(String chatId, String message, {String? imageUrl}) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('chats').doc(chatId).collection('messages').add({
      'senderId': user.uid,
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
      'imageUrl': imageUrl,
    });
  }

  String getChatId(String userA, String userB) {
    return (userA.compareTo(userB) < 0) ? '$userA-$userB' : '$userB-$userA';
  }
}
