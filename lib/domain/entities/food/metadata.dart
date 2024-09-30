import 'package:firebase_auth_demo/domain/entities/food/food.dart';

class Metadata {
  final List<Food> flavors;
  final List<Food> scenarios;
  final List<Food> themes;
  final List<Food> times;
  final List<Food> types;

  Metadata({
    required this.flavors,
    required this.scenarios,
    required this.themes,
    required this.times,
    required this.types,
  });
}
