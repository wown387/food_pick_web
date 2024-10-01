import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo/core/errors/failures.dart';
import 'package:firebase_auth_demo/domain/entities/auth/response_entity.dart';

abstract class SystemRepository {
  // Future<Either<Exception, UserModel>> signUp(body);

  Future<Either<Failure, ResponseEntity>> report(Map<String, dynamic> body);
}
