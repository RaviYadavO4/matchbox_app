import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/event_model.dart';

class EventProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<EventModel> _events = [];
  bool _isLoading = false;  

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;  

  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();  

    try {
      final snapshot = await _firestore.collection('events').orderBy('created_at', descending: true).get();
      _events = snapshot.docs.map((doc) => EventModel.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      debugPrint('Error fetching events: $e');
    } finally {
      _isLoading = false;  
      notifyListeners();  
    }
  }

  void clearEvents() {
    _events = [];
    notifyListeners();
  }
}

