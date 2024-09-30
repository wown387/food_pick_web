import 'package:equatable/equatable.dart';
import 'package:firebase_auth_demo/data/models/food/metadata_model.dart';
import 'package:firebase_auth_demo/data/models/food/ranked_food_model.dart';
import 'package:firebase_auth_demo/domain/entities/food/food.dart';
import 'package:firebase_auth_demo/domain/entities/food/food_compatibility.dart';
// import 'package:food_pick/data/models/food/metadata_model.dart';
// import 'package:food_pick/data/models/food/ranked_food_model.dart';
// import 'package:food_pick/domain/entities/food/food.dart';

abstract class DailyFoodsState extends Equatable {
  final DailyFoods? dailyFoods;
  final MetadataModel? metaData;
  final RankedFoodListModel? rankedFoods;
  final Food? recommendedFood;
  final FoodCompatibility? foodCompatibility;

  const DailyFoodsState({
    this.dailyFoods,
    this.metaData,
    this.rankedFoods,
    this.recommendedFood,
    this.foodCompatibility,
  });

  @override
  List<Object?> get props =>
      [dailyFoods, metaData, rankedFoods, recommendedFood, foodCompatibility];
}

class DailyFoodsInitial extends DailyFoodsState {}

class DailyFoodsLoading extends DailyFoodsState {}

// class DailyFoodsLoaded extends DailyFoodsState {
//   const DailyFoodsLoaded({
//     required DailyFoods dailyFoods,
//     required MetadataModel metaData,
//     required RankedFoodListModel rankedFoods,
//   }) : super(
//           dailyFoods: dailyFoods,
//           metaData: metaData,
//           rankedFoods: rankedFoods,
//         );
// }
class DailyFoodsLoaded extends DailyFoodsState {
  final DailyFoods dailyFoods;
  final MetadataModel metaData;
  final RankedFoodListModel rankedFoods;

  const DailyFoodsLoaded({
    required this.dailyFoods,
    required this.metaData,
    required this.rankedFoods,
  });
}

class SingleRecommendedFoodLoaded extends DailyFoodsState {
  const SingleRecommendedFoodLoaded({
    required Food recommendedFood,
    required DailyFoods? dailyFoods,
    required MetadataModel? metaData,
    RankedFoodListModel? rankedFoods,
  }) : super(
          recommendedFood: recommendedFood,
          dailyFoods: dailyFoods,
          metaData: metaData,
          rankedFoods: rankedFoods,
        );
}

class foodCompatibilityLoading extends DailyFoodsState {
  const foodCompatibilityLoading({
    Food? recommendedFood,
    DailyFoods? dailyFoods,
    MetadataModel? metaData,
    RankedFoodListModel? rankedFoods,
  }) : super(
          recommendedFood: recommendedFood,
          dailyFoods: dailyFoods,
          metaData: metaData,
          rankedFoods: rankedFoods,
        );
}

class foodCompatibilityLoaded extends DailyFoodsState {
  const foodCompatibilityLoaded({
    required FoodCompatibility foodCompatibility,
    Food? recommendedFood,
    DailyFoods? dailyFoods,
    MetadataModel? metaData,
    RankedFoodListModel? rankedFoods,
  }) : super(
          foodCompatibility: foodCompatibility,
          recommendedFood: recommendedFood,
          dailyFoods: dailyFoods,
          metaData: metaData,
          rankedFoods: rankedFoods,
        );
}

class DailyFoodsError extends DailyFoodsState {
  final String message;

  const DailyFoodsError(this.message);

  @override
  List<Object?> get props => [message, ...super.props];
}
