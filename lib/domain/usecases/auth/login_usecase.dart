import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo/data/models/user_model.dart';
import '../../entities/auth/user.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';

enum LoginType { google, normal, guest }

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);
  Future<Either<Exception, UserModel>> call(
      //     // {LoginType type = LoginType.google,
      //     // String? username,
      //     // String? password}
      String username,
      String password,
      LoginType loginType) async {
    try {
      // if (loginType == LoginType.google) {
      //   final googleAuthResult = await repository.signInWithGoogle();

      //   return googleAuthResult.fold((exception) => Left(exception),
      //       (authCredential) async {
      //     try {
      //       Either<Exception, UserModel> userProfile = await repository.getUserProfile(
      //           authCredential.accessToken, authCredential.id);
      //       return Right(userProfile);
      //     } catch (e) {
      //       return Left(Exception('Failed to get user profile: $e'));
      //     }
      //   });
      // }
      if (loginType == LoginType.normal) {
        final user = await repository.login(username, password);
        // print("googleAuthResultgoogleAuthResult ${googleAuthResult}");
        return user.fold(
            (exception) => Left(exception),
            (authCredential) => repository
                .getUserProfile(authCredential.accessToken, authCredential.id)
                .then((userProfileResult) => userProfileResult.fold(
                    (exception) => Left(exception),
                    (userModel) => Right(userModel))));
      } else if (loginType == LoginType.guest) {
        final user = await repository.guestLogin();
        print("login usecasecase");
        print(user);
        return user.fold((exception) => Left(exception), (user) => Right(user));
      } else {
        return Left(Exception('Login failed: login type error'));
      }
      // else {
      //   // 일반 로그인
      //   return await repository.login(username, password);
      // }
    } catch (e) {
      return Left(Exception('Login failed: $e'));
    }

    // if (loginType == LoginType.google) {
    //   // google return
    //   // login return
    //   // 데이터 가공s
    //   print("repository.signInWithGoogle()");
    //   final googleAuth = await repository.signInWithGoogle();
    //   googleAuth.fold((exception) {
    //     // 에러 처리
    //     print('Error: $exception');
    //   }, (userModel) {
    //     // 성공 처리
    //     final localUser =
    //         repository.getUserProfile(userModel.accessToken, userModel.id);
    //     print('Access Token: ${userModel.accessToken}');
    //   });

    //   // return repository.signInWithGoogle();
    // }
    // return repository.login(username, password);

    // if (loginType == LoginType.google) {
    //   return await repository.signInWithGoogle();
    // } else if (loginType == LoginType.normal) {
    //   if (username == null || password == null) {
    //     return Left(Exception(
    //         "Username and password must be provided for normal login"));
    //   }
    //   return await repository.login(username, password);
    // }
    // return Left(Exception("Invalid login type"));
  }
}

// Future<Either<Exception, User>> call(
//     // {LoginType type = LoginType.google,
//     // String? username,
//     // String? password}

//     ) async {
//   return await repository.signInWithGoogle();
//   // if (type == LoginType.google) {
//   //   return await repository.signInWithGoogle();
//   // } else if (type == LoginType.normal) {
//   //   if (username == null || password == null) {
//   //     return Left(Exception(
//   //         "Username and password must be provided for normal login"));
//   //   }
//   //   return await repository.login(username, password);
//   // }
//   // return Left(Exception("Invalid login type"));
// }

// Failure 클래스 예시
class ServerFailure extends Failure {
  final String message;
  ServerFailure(this.message);
}

class InvalidInputFailure extends Failure {
  final String message;
  InvalidInputFailure(this.message);
}

// Future<Either<Exception, User>> call() async {
//   return await repository.signInWithGoogle();
// }
