import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_demo/core/errors/exceptions.dart';
import 'package:firebase_auth_demo/data/datasources/locals/secure_storage_data_source.dart';
import 'package:firebase_auth_demo/data/models/response_model.dart';
import 'package:firebase_auth_demo/data/models/user_model.dart';
import 'package:firebase_auth_demo/domain/entities/auth/response_entity.dart';
import 'package:firebase_auth_demo/domain/repositories/auth_repository.dart';
import '../../domain/entities/auth/user.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../core/errors/failures.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageDataSource secureStorageDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorageDataSource,
  });

  @override
  Future<ResponseEntity> requestPasswordReset(String email) async {
    final responseModel = await remoteDataSource.requestPasswordReset(email);
    // repo 에서 엔티티로 가공,
    return responseModel.toEntity();
  }

  @override
  Future<ResponseEntity> validatePasswordReset(body) async {
    final responseModel = await remoteDataSource.validatePasswordReset(body);
    // repo 에서 엔티티로 가공,
    return responseModel.toEntity();
  }

  @override
  Future<void> deleteToken() async {
    await secureStorageDataSource.deleteToken();
  }

  @override
  Future<void> saveToken(String token) async {
    await secureStorageDataSource.saveToken(token);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorageDataSource.getToken();
  }

  @override
  Future<ResponseEntity> checkEmail(email) async {
    final responseModel = await remoteDataSource.checkEmail(email);
    return responseModel.toEntity();
  }

  @override
  // Future<Either<Exception, UserModel>> signUp(body) async {
  Future<Either<Failure, UserModel>> signUp(body) async {
    try {
      print("AuthRepositoryImpl signin google");
      final userSignup = await remoteDataSource.signUp(body);
      print("AuthRepositoryImpl end");
      return Right(userSignup);
      print("AuthRepositoryImpl ${userSignup.accessToken}");
      await saveToken(userSignup.accessToken);
      print("auth success");
      return Right(userSignup);
      // 캐시 혹은 여타 소스 가공
      //
      // return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure());
    } catch (e) {
      print("error ${e}");
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Exception, UserModel>> getUserProfile(
      String accessToken, int userId) async {
    try {
      print("getUserProfile ${accessToken} ${userId}");
      final userModel =
          await remoteDataSource.getUserProfile(accessToken, userId);
      print("userModeluserModel ${userModel}");
      return Right(userModel);
    } catch (e) {
      return Left(ServerException());
    }
  }

  @override
  Future<Either<Exception, UserModel>> login(
      String username, String password) async {
    try {
      print("normal usermodel login");
      final userModel = await remoteDataSource.login(username, password);
      await saveToken(userModel.accessToken);

      return Right(userModel);
    } catch (e) {
      return Left(ServerException());
    }
  }

  @override
  Future<Either<Exception, UserModel>> guestLogin() async {
    try {
      final localAuth = await remoteDataSource.guestLogin();
      print("normal usermodel login ${localAuth}");

      await saveToken(localAuth.accessToken);
      return Right(localAuth);
    } catch (e) {
      return Left(ServerException());
    }
  }

  @override
  Future<Either<Exception, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
