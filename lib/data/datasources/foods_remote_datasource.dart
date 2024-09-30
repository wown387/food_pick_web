// import 'package:food_pick/core/errors/exceptions.dart';
// import 'package:food_pick/data/models/food/metadata_model.dart';
// import 'package:food_pick/data/models/food/ranked_food_model.dart';
// import 'package:food_pick/domain/entities/food/food.dart';
// import 'package:food_pick/domain/entities/food/ranked_food_list.dart';
import 'package:firebase_auth_demo/core/errors/exceptions.dart';
import 'package:firebase_auth_demo/data/models/food/metadata_model.dart';
import 'package:firebase_auth_demo/data/models/food/ranked_food_model.dart';
import 'package:firebase_auth_demo/data/models/food_compatibility_model.dart';
import 'package:firebase_auth_demo/domain/entities/food/food.dart';
import 'package:firebase_auth_demo/domain/entities/food/food_compatibility.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class FoodsRemoteDataSource {
  Future<DailyFoods> getDailyFoods();
  Future<MetadataModel> getMetadata();
  Future<List<Food>> getSingleRecommendedFood(
      String accessToken, Map<String, dynamic> body);
  Future<RankedFoodListModel> getRankedFoodList();
  Future<FoodCompatibility> getFoodCompatibility(
      String accessToken, Map<String, dynamic> body);
}

class DailyFoodsRemoteDataSourceImpl implements FoodsRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  DailyFoodsRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<MetadataModel> getMetadata() async {
    final response = await client.get(Uri.parse('${baseUrl}/v0.1/foods/meta'));
    if (response.statusCode == 200) {
      String decodedBody = utf8.decode(response.bodyBytes);

      // JSON 파싱
      Map<String, dynamic> jsonMap = json.decode(decodedBody);
      return MetadataModel.fromJson(jsonMap);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<DailyFoods> getDailyFoods() async {
    print("DailyFoodsRemoteDataSource getDailyFoods");
    final response = await client.get(
      Uri.parse('${baseUrl}/v0.1/foods/daily-recommend'),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);

    if (response.statusCode == 200) {
      // UTF-8로 디코딩
      String decodedBody = utf8.decode(response.bodyBytes);

      // JSON 파싱
      Map<String, dynamic> jsonMap = json.decode(decodedBody);

      // 'dilayFoods' 키의 오타를 수정 (만약 API에서 수정이 불가능한 경우)
      // if (jsonMap.containsKey('dilayFoods')) {
      //   jsonMap['dailyFoods'] = jsonMap.remove('dilayFoods');
      // }
      print(jsonMap);
      // DailyFoods 객체로 변환
      return DailyFoods.fromJson(jsonMap);
    } else {
      throw ServerException();
    }

    // if (response.statusCode == 200) {
    //   return DailyFoods.fromJson(json.decode(response.body));
    // } else {
    //   throw ServerException();
    // }
  }

  // @override
  // Future<List<Food>> getSingleRecommendedFood(String accessToken  body) async {
  //   final response = await client.post(
  //     Uri.parse('${baseUrl}/v0.1/foods/recommend'),
  //     body: json.encode(body),
  //     headers: {'Content-Type': 'application/json', 'tkn': '${accessToken}'},
  //   );

  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     final foodNames = (jsonData['foodNames'] as List)
  //         .map((item) => Food.fromJson(item))
  //         .toList();
  //     return foodNames;
  //   } else {
  //     throw ServerException();
  //   }
  // }
  @override
  Future<FoodCompatibility> getFoodCompatibility(
      String accessToken, Map<String, dynamic> body) async {
    try {
      final response = await client.post(
        Uri.parse('${baseUrl}/v0.1/foods/select'),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'tkn': accessToken,
        },
      );

      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);
        // JSON 파싱
        Map<String, dynamic> jsonMap = json.decode(decodedBody);
        final foodCompatibilityModel = FoodCompatibilityModel.fromJson(jsonMap);

        return foodCompatibilityModel;
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      } else if (e is FormatException) {
        throw ServerException('Invalid response format: ${e.message}');
      } else {
        throw ServerException('An unexpected error occurred: $e');
      }
    }
  }

  @override
  Future<List<Food>> getSingleRecommendedFood(
      String accessToken, Map<String, dynamic> body) async {
    try {
      final response = await client.post(
        Uri.parse('${baseUrl}/v0.1/foods/recommend'),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'tkn': accessToken,
        },
      );

      if (response.statusCode == 200) {
        String decodedBody = utf8.decode(response.bodyBytes);

        // JSON 파싱
        Map<String, dynamic> jsonMap = json.decode(decodedBody);
        final jsonData = jsonMap;
        if (jsonData['foodNames'] is List) {
          return (jsonData['foodNames'] as List)
              .map((item) => Food.fromJson(item))
              .toList();
        } else {
          throw FormatException('Unexpected JSON format');
        }
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      } else if (e is FormatException) {
        throw ServerException('Invalid response format: ${e.message}');
      } else {
        throw ServerException('An unexpected error occurred: $e');
      }
    }
  }

  @override
  Future<RankedFoodListModel> getRankedFoodList() async {
    final response = await client.get(Uri.parse('${baseUrl}/v0.1/foods/rank'));
    if (response.statusCode == 200) {
      String decodedBody = utf8.decode(response.bodyBytes);

      // JSON 파싱
      Map<String, dynamic> jsonMap = json.decode(decodedBody);
      return RankedFoodListModel.fromJson(jsonMap);
    } else {
      throw ServerException();
    }
  }
}

// class ServerException implements Exception {}
