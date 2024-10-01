import 'package:firebase_auth_demo/core/errors/exceptions.dart';
import 'package:firebase_auth_demo/data/models/food/metadata_model.dart';
import 'package:firebase_auth_demo/data/models/response_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class SystemRemoteDataSource {
  Future<ResponseModel> report(String accessToken, Map<String, dynamic> body);
}

class SystemRemoteDataSourceImpl implements SystemRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  SystemRemoteDataSourceImpl({required this.client, required this.baseUrl});

  @override
  Future<ResponseModel> report(
      String accessToken, Map<String, dynamic> body) async {
    final response = await client.post(
      Uri.parse('${baseUrl}/v0.1/system/report'),
      body: json.encode(body),
      headers: {
        'Content-Type': 'application/json',
        'tkn': accessToken,
      },
    );
    if (response.statusCode == 200) {
      print("report ${response.body}");
      return ResponseModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}

// class ServerException implements Exception {}
