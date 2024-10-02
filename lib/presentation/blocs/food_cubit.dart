import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo/core/errors/failures.dart';
import 'package:firebase_auth_demo/data/models/food/metadata_model.dart';
import 'package:firebase_auth_demo/data/models/food/ranked_food_model.dart';
import 'package:firebase_auth_demo/domain/entities/food/food.dart';
import 'package:firebase_auth_demo/domain/entities/food/food_compatibility.dart';
import 'package:firebase_auth_demo/domain/usecases/food_usecase.dart';
import 'package:firebase_auth_demo/presentation/blocs/food_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyFoodsCubit extends Cubit<DailyFoodsState> {
  final GetFoodDataUseCase getFoodsDataUseCase;

  DailyFoodsCubit({required this.getFoodsDataUseCase})
      : super(DailyFoodsInitial());

  Future<void> getFoodCompatibility(Map<dynamic, dynamic> body) async {
    emit(foodCompatibilityLoading(
      recommendedFood: state.recommendedFood,
      dailyFoods: state.dailyFoods,
      metaData: state.metaData,
      rankedFoods: state.rankedFoods,
    ));
    try {
      Either<Failure, FoodCompatibility> foodCompatibilityResult =
          await getFoodsDataUseCase.getFoodCompatibility(body);
      print("resultresultresultresult${foodCompatibilityResult}");

      foodCompatibilityResult.fold(
        (failure) {
          // 실패 처리
          emit(DailyFoodsError(_mapFailureToMessage(failure)));
        },
        (foodCompatibility) {
          // 성공 처리
          if (foodCompatibility != null) {
            print(foodCompatibility.foodCompatibility);
            emit(foodCompatibilityLoaded(
              foodCompatibility: foodCompatibility,
              recommendedFood: state.recommendedFood,
              dailyFoods: state.dailyFoods,
              metaData: state.metaData,
              rankedFoods: state.rankedFoods,
            ));
          } else {
            emit(DailyFoodsError('No recommended food found'));
          }
        },
      );
    } catch (e) {
      emit(DailyFoodsError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> getSingleRecommendedFood(Map<String, dynamic> body) async {
    try {
      Either<Failure, List<Food>> result =
          await getFoodsDataUseCase.getSingleRecommendedFood(body);
      print("resultresultresultresult${result}");

      result.fold(
        (failure) {
          // 실패 처리
          emit(DailyFoodsError(_mapFailureToMessage(failure)));
        },
        (recommendedFoods) {
          // 성공 처리
          if (recommendedFoods.isNotEmpty) {
            emit(SingleRecommendedFoodLoaded(
                recommendedFood: recommendedFoods[0],
                dailyFoods: state.dailyFoods,
                metaData: state.metaData,
                rankedFoods: state.rankedFoods,
                selectedFoodType: body,
                // previousAnswer: [
                //   ...(state.previousAnswer ?? []),
                //   if (recommendedFoods.isNotEmpty) recommendedFoods[0].name,

                // ]
                previousAnswer: [
                  (state?.previousAnswer?.isNotEmpty == true
                          ? state!.previousAnswer![0] + ' '
                          : '') +
                      (recommendedFoods.isNotEmpty
                          ? recommendedFoods[0].name
                          : '')
                ].where((s) => s.isNotEmpty).toList()));
          } else {
            emit(DailyFoodsError('No recommended food found'));
          }
        },
      );
    } catch (e) {
      emit(DailyFoodsError('An unexpected error occurred: ${e.toString()}'));
    }
  }

  Future<void> getDailyFoods() async {
    emit(DailyFoodsLoading());
    try {
      emit(DailyFoodsLoading());
      final dailyFoodsResult = await getFoodsDataUseCase.getDailyFoods();
      final foodMetaResult = await getFoodsDataUseCase.getFoodMetadata();
      final rankedFoodListResult =
          await getFoodsDataUseCase.getRankedFoodList();

      Either<Failure, (DailyFoods, MetaDataModel, RankedFoodListModel)>
          combinedResult = dailyFoodsResult.fold(
              (failure) => Left(failure),
              (dailyFoods) => foodMetaResult.fold(
                  (failure) => Left(failure),
                  (foodMeta) => rankedFoodListResult.fold(
                      (failure) => Left(failure),
                      (rankedFoodList) =>
                          Right((dailyFoods, foodMeta, rankedFoodList)))));

      // 조합된 결과를 처리
      combinedResult.fold(
          (failure) => emit(DailyFoodsError(failure.toString())), (result) {
        emit(DailyFoodsLoaded(
          dailyFoods: result.$1,
          metaData: result.$2,
          rankedFoods: result.$3, // rankedFoodList 추가
        ));
      });
    } catch (e) {
      emit(DailyFoodsError(e.toString()));
    }
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      return 'Server error occurred';
    case NetworkFailure:
      return 'Network error occurred';
    case CacheFailure:
      return 'Cache error occurred';
    default:
      return 'Unexpected error occurred';
  }
}
