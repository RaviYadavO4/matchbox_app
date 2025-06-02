class EventModel {
  final String id;
  final String title;
  final String location;
  final String description;
  final String date;
  final Map<String, String> questions;

  EventModel({
    required this.id,
    required this.title,
    required this.location,
    required this.description,
    required this.date,
    required this.questions,
  });

  factory EventModel.fromMap(Map<String, dynamic> data, String documentId) {
    final questionsData = Map<String, dynamic>.from(data['questions'] ?? {});
    final questions = questionsData.map((key, value) => MapEntry(key, value.toString()));

    return EventModel(
      id: documentId,
      title: data['title'] ?? '',
      location: data['location'] ?? '',
      description: data['description'] ?? '',
      date: data['date'] ?? '',
      questions: questions,
    );
  }
}
