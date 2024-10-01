import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo/core/errors/failures.dart';
import 'package:firebase_auth_demo/domain/entities/auth/response_entity.dart';
import 'package:firebase_auth_demo/domain/repositories/system_repository.dart';

class SystemRequestUseCase {
  final SystemRepository repository;

  SystemRequestUseCase(this.repository);

  // 1:1 문의 메소드
  Future<Either<Failure, ResponseEntity>> report(body) async {
    return await repository.report(body);
  }
}
