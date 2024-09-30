import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo/data/models/response_model.dart';
import 'package:firebase_auth_demo/domain/entities/auth/response_entity.dart';
import '../../core/errors/failures.dart';
import '../../data/models/user_model.dart';

abstract class AuthRepository {
  // Future<Either<Exception, UserModel>> signUp(body);
  Future<ResponseEntity> checkEmail(email);
  Future<Either<Failure, UserModel>> signUp(body);
  Future<Either<Exception, UserModel>> getUserProfile(
      String accessToken, int userId);
  Future<Either<Exception, UserModel>> login(String username, String password);
  Future<Either<Exception, UserModel>> guestLogin();
  Future<Either<Failure, void>> logout();
  Future<Either<Exception, void>> signOut();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<ResponseEntity> requestPasswordReset(String email);
  Future<ResponseEntity> validatePasswordReset(body);
}
