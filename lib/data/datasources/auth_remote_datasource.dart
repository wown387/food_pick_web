import 'package:firebase_auth_demo/core/constants/app_constants.dart';
import 'package:firebase_auth_demo/core/errors/exceptions.dart';
import 'package:firebase_auth_demo/data/models/response_model.dart';
import 'package:firebase_auth_demo/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class AuthRemoteDataSource {
  Future<ResponseModel> checkEmail(email);
  Future<ResponseModel> changeUserProfile(String accessToken, body);
  Future<UserModel> signUp(body);
  Future<UserModel> getUserProfile(String accessToken, int userId);
  Future<void> signOut();
  Future<UserModel> login(String username, String password);
  Future<UserModel> guestLogin();
  Future<void> logout();
  Future<ResponseModel> requestPasswordReset(String email);
  Future<ResponseModel> validatePasswordReset(body);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({
    required this.client,
  });

  @override
  Future<ResponseModel> requestPasswordReset(String email) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.apiBaseUrl}/v0.1/auth/password/request'),
        body: json.encode({'email': email}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return ResponseModel.fromJson(json.decode(response.body));
      } else {
        return ResponseModel.fromJson(false);
      }
    } catch (e) {
      throw Exception('Failed to request password reset');
    }
  }

  @override
  Future<ResponseModel> validatePasswordReset(body) async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.apiBaseUrl}/v0.1/auth/password/validate'),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return ResponseModel.fromJson(json.decode(response.body));
      } else {
        return ResponseModel.fromJson(false);
      }
    } catch (e) {
      throw Exception('Failed to request password reset');
    }
  }

  @override
  Future<ResponseModel> checkEmail(email) async {
    final response = await client.get(Uri.parse(
        '${AppConstants.apiBaseUrl}/v0.1/auth/email/check?email=${email}'));
    if (response.statusCode == 200) {
      return ResponseModel.fromJson(json.decode(response.body));
    } else {
      return ResponseModel.fromJson(false);
    }
  }

  @override
  Future<ResponseModel> changeUserProfile(String accessToken, body) async {
    final response = await client.put(
      Uri.parse('${AppConstants.apiBaseUrl}/v0.1/users/profile'),
      body: json.encode(body),
      headers: {'Content-Type': 'application/json', 'tkn': '${accessToken}'},
    );
    if (response.statusCode == 200) {
      return ResponseModel.fromJson(json.decode(response.body));
    } else {
      return ResponseModel.fromJson(false);
    }
  }

  @override
  Future<UserModel> signUp(body) async {
    print("remote body ${body}");
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.apiBaseUrl}/v0.1/auth/signup'),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );
      print("signUp with normal ${response.body}");
      UserModel userAuth =
          UserModel.fromNormalAuthJson(json.decode(response.body));
      return userAuth;
    } catch (e) {
      throw ServerException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> getUserProfile(String accessToken, int userId) async {
    try {
      print(' getUserProfile ${AppConstants.apiBaseUrl}/v0.1/users/${userId}');
      final response = await client.get(
        Uri.parse('${AppConstants.apiBaseUrl}/v0.1/user/${userId}'),
        headers: {'Content-Type': 'application/json', 'tkn': '${accessToken}'},
      );
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200) {
        print('${response.statusCode} response.statusCoderesponse.statusCode');

        String decodedBody = utf8.decode(response.bodyBytes);
        // JSON 파싱
        Map<String, dynamic> jsonMap = json.decode(decodedBody);
        final user = UserModel.fromProfileJson(jsonMap);
        print('${user.birth} useruser');
        return user;
      } else {
        throw AuthException('Invalid credentials');
      }
    } catch (e) {
      print("errorerrorerror ${e}");
      throw ServerException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> login(String username, String password) async {
    try {
      print("login remote start ${username} ${password}");
      final response = await client.post(
        Uri.parse('${AppConstants.apiBaseUrl}/v0.1/auth/signin'),
        body: json.encode({'email': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return UserModel.fromAuthJson(json.decode(response.body));
      } else {
        throw AuthException('Invalid credentials');
      }
    } catch (e) {
      throw ServerException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> guestLogin() async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.apiBaseUrl}/v0.1/auth/guest'),
        body: json.encode({}),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);

      if (response.statusCode == 200) {
        return UserModel.fromGuestAuthJson(json.decode(response.body));
      } else {
        throw AuthException('Invalid credentials');
      }
    } catch (e) {
      throw ServerException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await client.post(
        Uri.parse('${AppConstants.apiBaseUrl}/logout'),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      throw ServerException('Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await client.post(
        Uri.parse('${AppConstants.apiBaseUrl}/logout'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw ServerException('Logout failed');
      }
    } catch (e) {
      throw ServerException('Logout failed: ${e.toString()}');
    }
  }
}
