import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo/data/models/user_model.dart';
import 'package:firebase_auth_demo/domain/entities/auth/response_entity.dart';
import '../../repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<ResponseEntity> deleteUser() async {
    return await repository.deleteUser();
  }

  Future<ResponseEntity> changePassword(body) async {
    return await repository.changeUserProfile(body);
  }

  Future<ResponseEntity> requestPasswordReset(email) async {
    return await repository.requestPasswordReset(email);
  }

  Future<ResponseEntity> validatePasswordReset(body) async {
    return await repository.validatePasswordReset(body);
  }

  Future<ResponseEntity> checkEmail(email) async {
    return await repository.checkEmail(email);
  }

  Future<ResponseEntity> requestEmail(email) async {
    return await repository.requestEmail(email);
  }

  Future<Either<Failure, UserModel>> regist(body) async {
    print("regist start");
    // final user = await repository.signUp(body);
    // print("signupusecase user ${user}");
    // return user;
    // return repository.signUp(body);
    print("end");
    // Future<Either<Failure, UserModel>> regist(body) async {
    // print("start");
    final user = await repository.signUp(body);
    return user.fold((exception) => Left(exception),
        (user) => Right(UserModel(accessToken: "", id: 0)));
  }

  // Future<Either<Exception, UserModel>> call(body) async {
  //   // return await repository.signUp(body);
  //   final user = await repository.signUp(body);
  //   print("SignupUseCase ${user}");
  //   return user;
  //   // return user.fold((exception) => Left(exception), (user) {
  //   //   print("fold user ${user.accessToken}");
  //   //   return Right(user);
  //   // });
  // }

  // Future<Either<Failure, void>> call() async {
  //   return await repository.logout();
  // }
}
