import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo/core/errors/failures.dart';
import 'package:firebase_auth_demo/data/models/food/metadata_model.dart';
import 'package:firebase_auth_demo/data/models/food/ranked_food_model.dart';
import 'package:firebase_auth_demo/domain/entities/food/food.dart';
import 'package:firebase_auth_demo/domain/entities/food/food_compatibility.dart';
import 'package:firebase_auth_demo/domain/repositories/food_repository.dart';

class GetFoodDataUseCase {
  final FoodRepository repository;

  GetFoodDataUseCase(this.repository);

  // DailyFoods 데이터를 가져오는 메서드
  Future<Either<Failure, DailyFoods>> getDailyFoods() async {
    return await repository.getDailyFoods();
  }

  // 특정 음식의 Metadata를 가져오는 메서드
  Future<Either<Failure, MetadataModel>> getFoodMetadata() async {
    return await repository.getMetadata();
  }

  Future<Either<Failure, RankedFoodListModel>> getRankedFoodList() async {
    return await repository.getRankedFoodList();
  }

  Future<Either<Failure, List<Food>>> getSingleRecommendedFood(body) async {
    return await repository.getSingleRecommendedFood(body);
  }

  Future<Either<Failure, FoodCompatibility>> getFoodCompatibility(body) async {
    return await repository.getFoodCompatibility(body);
  }
}
