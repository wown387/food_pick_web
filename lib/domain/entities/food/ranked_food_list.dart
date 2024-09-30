import 'package:firebase_auth_demo/domain/entities/food/food.dart';

class RankedFoodList {
  final List<Food> flavors;
  final List<Food> scenarios;
  final List<Food> themes;

  RankedFoodList({
    required this.flavors,
    required this.scenarios,
    required this.themes,
  });
}
