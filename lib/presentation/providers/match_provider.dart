import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/my_matched_model.dart';

class MatchProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<MyMatchModel> _matches = [];
  List<MyMatchModel> get matches => _matches;

  MyMatchModel? _currentMatch;
  MyMatchModel? get currentMatch => _currentMatch;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Fetch match for a single event
  Future<void> fetchMatchResult(String eventId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final doc = await _firestore
          .collection('events')
          .doc(eventId)
          .collection('participants')
          .doc(userId)
          .get();

      if (doc.exists && doc.data()?['match'] != null) {
        final matchData = doc.data()!['match'];
        if (matchData is Map<String, dynamic>) {
          _currentMatch = MyMatchModel.fromMap(eventId, matchData);
        } else {
          _currentMatch = null;
        }
      } else {
        _currentMatch = null;
      }
    } catch (e) {
      print('Error fetching match: $e');
      _currentMatch = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fetch matches from all events
  Future<void> fetchMatches() async {
    _isLoading = true;
    _matches = [];
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final eventsSnapshot = await _firestore.collection('events').get();

      for (final doc in eventsSnapshot.docs) {
        final participantRef = doc.reference.collection('participants').doc(user.uid);
        final participantDoc = await participantRef.get();

        if (participantDoc.exists && participantDoc.data()?['match'] != null) {
          final matchData = participantDoc.data()!['match'];
          if (matchData is Map<String, dynamic>) {
            _matches.add(MyMatchModel.fromMap(doc.id, matchData));
          }
        }
      }
    } catch (e) {
      print('Error fetching matches: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
