class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? 'No Name',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }
}
