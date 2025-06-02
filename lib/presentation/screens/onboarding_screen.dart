import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:matchbox_app/config.dart';
import 'package:matchbox_app/presentation/screens/my_match_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final String eventId;

  const OnboardingScreen({super.key, required this.eventId});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, String> questions = {};
  Map<String, String> answers = {};
  bool isSubmitting = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final eventDoc = await _firestore.collection('events').doc(widget.eventId).get();

      if (eventDoc.exists) {
        final data = eventDoc.data();
        if (data != null && data['questions'] != null) {
          final questionsData = Map<String, dynamic>.from(data['questions']);
          final sortedKeys = questionsData.keys.toList()..sort();
          setState(() {
            questions = {
              for (var key in sortedKeys) key: questionsData[key].toString()
            };
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load questions: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>?> findBestMatchWithGemini({
  required Map<String, String> currentAnswers,
  required List<Map<String, dynamic>> others,
}) async {
  const geminiApiKey = 'YOUR_GEMINI_API_KEY';
  const url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro-latest:generateContent?key=$geminiApiKey';

  final prompt = '''
You are a matchmaking assistant. Given one user's answers and a list of other participants' answers, identify the best match. Return JSON with keys: userId, score, reason.

Current user's answers:
${currentAnswers.entries.map((e) => '${e.key}: ${e.value}').join('\n')}

Participants:
${others.map((u) => 'ID: ${u["userId"]}\nAnswers:\n${(u["answers"] as Map<String, dynamic>).entries.map((e) => '${e.key}: ${e.value}').join('\n')}').join('\n\n')}
''';

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'contents': [
        {
          'parts': [{'text': prompt}]
        }
      ]
    }),
  );

  if (response.statusCode == 200) {
    final content = jsonDecode(response.body);
    
    final text = content['candidates']?[0]?['content']?['parts']?[0]?['text'];
    final jsonString = text
      .replaceAll(RegExp(r'```json'), '')
      .replaceAll(RegExp(r'```'), '')
      .trim();

      debugPrint('Gemini parsing cleanedText: ${jsonString}');
   
    try {
 


  final parsed = jsonDecode(jsonString);
  print('candidates $parsed');
  return parsed;
} catch (e) {
  print('Gemini parsing failed: $text');
}
  } else {
    debugPrint('Gemini API error: ${response.statusCode} ${response.body}');
  }

  return null;
}




  Future<void> _submitAnswers() async {
  if (answers.length != questions.length) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please answer all questions')),
    );
    return;
  }

  setState(() {
    isSubmitting = true;
  });

  try {
    final user = _auth.currentUser;
    if (user == null) return;

    final userRef = _firestore
        .collection('events')
        .doc(widget.eventId)
        .collection('participants')
        .doc(user.uid);

    await userRef.set({
      'answers': answers,
      'userId': user.uid,
      'email': user.email,
      'timestamp': FieldValue.serverTimestamp(),
    });



    final snapshot = await _firestore
        .collection('events')
        .doc(widget.eventId)
        .collection('participants')
        .get();

    final others = snapshot.docs
        .where((doc) => doc.id != user.uid && doc.data()['answers'] != null)
        .map((doc) => doc.data())
        .toList();

    final matchResult = await findBestMatchWithGemini(
      currentAnswers: answers,
      others: others.cast<Map<String, dynamic>>(),
    );

    if (matchResult != null) {
      final matchedUserId = matchResult['userId'];
      final matchedUserDoc = snapshot.docs.firstWhere((d) => d.id == matchedUserId);

      final matchedData = matchedUserDoc.data();

      await userRef.update({
        'match': {
          'matchedUserId': matchedUserId,
          'matchedUserName': matchedData['email'] ?? 'Anonymous',
          'matchedPhotoUrl': matchedData['photoUrl'] ?? '',
        }
      });

      await _firestore
          .collection('events')
          .doc(widget.eventId)
          .collection('participants')
          .doc(matchedUserId)
          .update({
        'match': {
          'matchedUserId': user.uid,
          'matchedUserName': user.email ?? 'You',
          'matchedPhotoUrl': '',
        }
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Answers submitted and match generated!')),
    );

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => MyMatchScreen(eventId: widget.eventId)));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  } finally {
    setState(() {
      isSubmitting = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding Questions')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : questions.isEmpty
              ? const Center(child: Text('No questions found for this event.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: questions.length,
                          itemBuilder: (context, index) {
                            final key = questions.keys.elementAt(index);
                            final questionText = questions[key]!;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${index + 1}. $questionText',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  TextField(
                                    decoration: const InputDecoration(
                                      hintText: 'Your answer',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        answers[key] = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : _submitAnswers,
                          child: isSubmitting
                              ? const CircularProgressIndicator(color: Colors.white)
                              :  Text('Submit Answers',style: TextStyle(color: appColors.white),),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
