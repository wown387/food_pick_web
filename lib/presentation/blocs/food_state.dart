import 'package:equatable/equatable.dart';
import 'package:firebase_auth_demo/data/models/food/metadata_model.dart';
import 'package:firebase_auth_demo/data/models/food/ranked_food_model.dart';
import 'package:firebase_auth_demo/domain/entities/food/food.dart';
import 'package:firebase_auth_demo/domain/entities/food/food_compatibility.dart';

abstract class DailyFoodsState extends Equatable {
  final DailyFoods? dailyFoods;
  final MetaDataModel? metaData;
  final RankedFoodListModel? rankedFoods;
  final Food? recommendedFood;
  final FoodCompatibility? foodCompatibility;
  final dynamic? selectedFoodType;
  final List<String>? previousAnswer;

  const DailyFoodsState(
      {this.dailyFoods,
      this.metaData,
      this.rankedFoods,
      this.recommendedFood,
      this.foodCompatibility,
      this.selectedFoodType,
      this.previousAnswer});

  // 이전 상태와 동일한지 비교 여부 이것을 통해서 재 랜더링 할지 결정
  @override
  List<Object?> get props => [
        dailyFoods,
        metaData,
        rankedFoods,
        recommendedFood,
        foodCompatibility,
        selectedFoodType,
        previousAnswer
      ];
}

class DailyFoodsInitial extends DailyFoodsState {}

class DailyFoodsLoading extends DailyFoodsState {}

class DailyFoodsLoaded extends DailyFoodsState {
  final DailyFoods dailyFoods;
  final MetaDataModel metaData;
  final RankedFoodListModel rankedFoods;

  const DailyFoodsLoaded({
    required this.dailyFoods,
    required this.metaData,
    required this.rankedFoods,
  });
}

class SingleRecommendedFoodLoaded extends DailyFoodsState {
  const SingleRecommendedFoodLoaded({
    required dynamic selectedFoodType,
    required Food recommendedFood,
    required DailyFoods? dailyFoods,
    required MetaDataModel? metaData,
    RankedFoodListModel? rankedFoods,
    List<String>? previousAnswer,
  }) : super(
            recommendedFood: recommendedFood,
            dailyFoods: dailyFoods,
            metaData: metaData,
            rankedFoods: rankedFoods,
            selectedFoodType: selectedFoodType,
            previousAnswer: previousAnswer);
}

class foodCompatibilityLoading extends DailyFoodsState {
  const foodCompatibilityLoading({
    Food? recommendedFood,
    DailyFoods? dailyFoods,
    MetaDataModel? metaData,
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
    MetaDataModel? metaData,
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
