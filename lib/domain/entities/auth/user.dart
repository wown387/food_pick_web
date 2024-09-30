class User {
  final int id;
  final String accessToken;
  final String? username;
  final String? email;
  final String? birth;
  final String? sex;
  final String? photoUrl;

  User({
    required this.id,
    required this.accessToken,
    required this.username,
    this.email,
    this.birth,
    this.sex,
    this.photoUrl,
  });
}
