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
  Future<MetaDataModel> getMetadata();
  Future<List<Food>> getSingleRecommendedFood(
      String accessToken, Map<String, dynamic> body);
  Future<RankedFoodListModel> getRankedFoodList();
  Future<FoodCompatibility> getFoodCompatibility(String accessToken, body);
}

class DailyFoodsRemoteDataSourceImpl implements FoodsRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  DailyFoodsRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<MetaDataModel> getMetadata() async {
    final response = await client.get(Uri.parse('${baseUrl}/v0.1/foods/meta'));
    if (response.statusCode == 200) {
      String decodedBody = utf8.decode(response.bodyBytes);

      // JSON 파싱
      Map<String, dynamic> jsonMap = json.decode(decodedBody);
      return MetaDataModel.fromJson(jsonMap);
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
      print(jsonMap);
      // DailyFoods 객체로 변환
      return DailyFoods.fromJson(jsonMap);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<FoodCompatibility> getFoodCompatibility(
      String accessToken, body) async {
    print("getFoodCompatibility ${body}");
    try {
      final response = await client.post(
        Uri.parse('${baseUrl}/v0.1/foods/select'),
        body: json.encode(body),
        headers: {
          'Content-Type': 'application/json',
          'tkn': accessToken,
        },
      );
      print("response.body ${response.body}");
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
      print("error ${e}");
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
      print(" getSingleRecommendedFood ${body}");
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
