import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo/core/errors/exceptions.dart';
import 'package:firebase_auth_demo/core/errors/failures.dart';
import 'package:firebase_auth_demo/data/datasources/foods_remote_datasource.dart';
import 'package:firebase_auth_demo/data/datasources/locals/secure_storage_data_source.dart';
import 'package:firebase_auth_demo/data/models/food/metadata_model.dart';
import 'package:firebase_auth_demo/data/models/food/ranked_food_model.dart';
import 'package:firebase_auth_demo/data/models/food_compatibility_model.dart';
import 'package:firebase_auth_demo/domain/entities/food/food.dart';
import 'package:firebase_auth_demo/domain/entities/food/food_compatibility.dart';
import 'package:firebase_auth_demo/domain/repositories/food_repository.dart';

class FoodRepositoryImpl implements FoodRepository {
  final FoodsRemoteDataSource remoteDataSource;
  final SecureStorageDataSource secureStorageDataSource;
  // final NetworkInfo networkInfo;

  FoodRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorageDataSource,
    // required this.networkInfo,
  });
  @override
  Future<Either<Failure, FoodCompatibility>> getFoodCompatibility(body) async {
    // 예시용 로컬 데이터 사용 (API나 DB에서 가져온다고 가정)

    final token = await secureStorageDataSource.getToken();
    print("tokentokentoken!!!! ${token}");
    try {
      final remoteFoodNames =
          await remoteDataSource.getFoodCompatibility('${token}', body);
      return Right(remoteFoodNames);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, DailyFoods>> getDailyFoods() async {
    try {
      final dailyFoodsData = await remoteDataSource.getDailyFoods();
      return Right(dailyFoodsData);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, MetaDataModel>> getMetadata() async {
    try {
      final metadaFoodsData = await remoteDataSource.getMetadata();
      return Right(metadaFoodsData);
    } on ServerException {
      return Left(ServerFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, RankedFoodListModel>> getRankedFoodList() async {
    // if (await networkInfo.isConnected) {

    try {
      final remoteFoodNames = await remoteDataSource.getRankedFoodList();
      return Right(remoteFoodNames);
    } on ServerException {
      return Left(ServerFailure(message: "error fetch rankFood"));
    }
  }

  @override
  Future<Either<Failure, List<Food>>> getSingleRecommendedFood(
      Map<String, dynamic> body) async {
    // if (await networkInfo.isConnected) {
    final token = await secureStorageDataSource.getToken();
    print("tokentokentoken!!!! ${token} ${body} getSingleRecommendedFood");
    try {
      final remoteFoodNames =
          await remoteDataSource.getSingleRecommendedFood('${token}', body);
      return Right(remoteFoodNames);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  // else {
  //   return Left(NetworkFailure());
  // }
  // }
}

class FetchDataException implements Exception {
  final String message;
  FetchDataException(this.message);
}
