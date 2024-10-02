import '../../domain/entities/auth/user.dart';

class UserModel extends User {
  UserModel({
    required String accessToken,
    required int id,
    String? email,
    String? username,
    String? birth,
    String? sex,
    String? photoUrl,
  }) : super(
          id: id,
          accessToken: accessToken,
          email: email,
          username: username,
          birth: birth,
          sex: sex,
          photoUrl: photoUrl,
        );

  // 첫 번째 API 응답을 처리하는 팩토리 메서드

  factory UserModel.fromNormalAuthJson(Map<String, dynamic> json) {
    return UserModel(
      id: 0,
      accessToken: json['accessToken'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      username: null,
      birth: null,
      sex: null,
    );
  }

  factory UserModel.fromAuthJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['userID'],
      accessToken: json['accessToken'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      username: null,
      birth: null,
      sex: null,
    );
  }
  factory UserModel.fromGuestAuthJson(Map<String, dynamic> json) {
    return UserModel(
      id: -1,
      accessToken: json['accessToken'],
      email: json['email'],
      photoUrl: json['photoUrl'],
      username: null,
      birth: null,
      sex: null,
    );
  }

  // 두 번째 API 응답을 처리하는 팩토리 메서드
  factory UserModel.fromProfileJson(Map<String, dynamic> json) {
    return UserModel(
      id: 0,
      accessToken: '', // 이 API에서는 accessToken을 제공하지 않음
      username: json['name'],
      email: json['email'],
      birth: json['birth'],
      sex: json['sex'],
      photoUrl: null,
    );
  }

  // 두 API 응답을 합치는 메서드
  UserModel merge(UserModel other) {
    return UserModel(
      id: this.id,
      accessToken:
          this.accessToken.isNotEmpty ? this.accessToken : other.accessToken,
      email: this.email ?? other.email,
      username: other.username ?? this.username,
      birth: other.birth ?? this.birth,
      sex: other.sex ?? this.sex,
      photoUrl: this.photoUrl ?? other.photoUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': username,
      'photoUrl': photoUrl,
      'accessToken': accessToken,
      'birth': birth,
      'sex': sex,
    };
  }
}
