import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  List<TextEditingController> _questionControllers = [];

  bool isSubmitting = false;

  void _addQuestionField() {
    setState(() {
      _questionControllers.add(TextEditingController());
    });
  }

  void _removeQuestionField(int index) {
    setState(() {
      _questionControllers.removeAt(index);
    });
  }

  Future<void> _submitEvent() async {
    if (_titleController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _dateController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all event fields')),
      );
      return;
    }

    final Map<String, String> questions = {};
    for (int i = 0; i < _questionControllers.length; i++) {
      final text = _questionControllers[i].text.trim();
      if (text.isNotEmpty) {
        questions['q${i + 1}'] = text;
      }
    }

    setState(() {
      isSubmitting = true;
    });

    try {
      await _firestore.collection('events').add({
        'title': _titleController.text.trim(),
        'location': _locationController.text.trim(),
        'description': _descriptionController.text.trim(),
        'date': _dateController.text.trim(),
        'questions': questions,
        'created_at': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully')),
      );

      _titleController.clear();
      _locationController.clear();
      _descriptionController.clear();
      _dateController.clear();
      _questionControllers = [];
      setState(() {});
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

  Widget _buildQuestionFields() {
    return Column(
      children: List.generate(_questionControllers.length, (index) {
        return Row(
          children: [
            Expanded(
              child: TextField(
                controller: _questionControllers[index],
                decoration: InputDecoration(
                  labelText: 'Question ${index + 1}',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeQuestionField(index),
            ),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    for (var controller in _questionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Event Title'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Questions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addQuestionField,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Question'),
                ),
              ],
            ),
            _buildQuestionFields(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : _submitEvent,
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Create Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
