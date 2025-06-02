class MyMatchModel {
  final String eventId;
  final String matchedUserId;
  final String matchedUserName;
  final String matchedPhotoUrl;

  MyMatchModel({
    required this.eventId,
    required this.matchedUserId,
    required this.matchedUserName,
    required this.matchedPhotoUrl,
  });

  factory MyMatchModel.fromMap(String eventId, Map<String, dynamic> data) {
    return MyMatchModel(
      eventId: eventId,
      matchedUserId: data['matchedUserId'] ?? '',
      matchedUserName: data['matchedUserName'] ?? '',
      matchedPhotoUrl: data['matchedPhotoUrl'] ?? '',
    );
  }
}
