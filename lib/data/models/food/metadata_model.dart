

import 'package:firebase_auth_demo/domain/entities/food/food.dart';
import 'package:firebase_auth_demo/domain/entities/food/metadata.dart';

class MetadataModel extends Metadata {
  MetadataModel({
    required List<Food> flavors,
    required List<Food> scenarios,
    required List<Food> themes,
    required List<Food> times,
    required List<Food> types,
  }) : super(
          flavors: flavors,
          scenarios: scenarios,
          themes: themes,
          times: times,
          types: types,
        );

  factory MetadataModel.fromJson(Map<String, dynamic> json) {
    return MetadataModel(
      flavors: _parseItems(json['metaData']['flavors']),
      scenarios: _parseItems(json['metaData']['scenarios']),
      themes: _parseItems(json['metaData']['themes']),
      times: _parseItems(json['metaData']['times']),
      types: _parseItems(json['metaData']['types']),
    );
  }

  static List<Food> _parseItems(List<dynamic> foodList) {
    return foodList.map((food) => Food.fromJson(food)).toList();
  }
}
