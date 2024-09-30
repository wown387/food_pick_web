import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo/core/errors/failures.dart';
import 'package:firebase_auth_demo/data/models/food/metadata_model.dart';
import 'package:firebase_auth_demo/data/models/food/ranked_food_model.dart';
import 'package:firebase_auth_demo/domain/entities/food/food.dart';
import 'package:firebase_auth_demo/domain/entities/food/food_compatibility.dart';

abstract class FoodRepository {
  Future<Either<Failure, DailyFoods>> getDailyFoods();
  Future<Either<Failure, MetadataModel>> getMetadata();
  Future<Either<Failure, List<Food>>> getSingleRecommendedFood(
      Map<String, dynamic> body);
  Future<Either<Failure, RankedFoodListModel>> getRankedFoodList();
  Future<Either<Failure, FoodCompatibility>> getFoodCompatibility(body);
}
