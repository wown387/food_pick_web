import 'package:firebase_auth_demo/domain/entities/food/food_compatibility.dart';

class FoodCompatibilityModel extends FoodCompatibility {
  FoodCompatibilityModel({required String foodCompatibility})
      : super(foodCompatibility: foodCompatibility);

  factory FoodCompatibilityModel.fromJson(Map<String, dynamic> json) {
    return FoodCompatibilityModel(
      foodCompatibility: json['foodCompatibility'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodCompatibility': foodCompatibility,
    };
  }
}
