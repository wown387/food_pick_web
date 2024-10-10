import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo/core/errors/exceptions.dart';
import 'package:firebase_auth_demo/core/errors/failures.dart';
import 'package:firebase_auth_demo/data/datasources/locals/secure_storage_data_source.dart';
import 'package:firebase_auth_demo/data/datasources/system_remote_datasource.dart';
import 'package:firebase_auth_demo/domain/entities/auth/response_entity.dart';
import 'package:firebase_auth_demo/domain/repositories/system_repository.dart';
import 'package:flutter/material.dart';

class SystemRepositoryImpl implements SystemRepository {
  final SystemRemoteDataSource remoteDataSource;
  final SecureStorageDataSource secureStorageDataSource;
  // final NetworkInfo networkInfo;

  SystemRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorageDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, ResponseEntity>> report(
      Map<String, dynamic> body) async {
    // if (await networkInfo.isConnected) {
    final token = await secureStorageDataSource.getToken();
    debugPrint("tokentokentoken!!!! ${token} ${body} getSingleRecommendedFood");
    try {
      final remoteSystemReportModel =
          await remoteDataSource.report('${token}', body);
      // return remoteSystemReportModel.toEntity();
      return Right(remoteSystemReportModel.toEntity());
      // return Right(remoteFoodNames);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

class FetchDataException implements Exception {
  final String message;
  FetchDataException(this.message);
}
