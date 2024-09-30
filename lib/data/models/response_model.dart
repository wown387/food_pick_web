import 'package:firebase_auth_demo/domain/entities/auth/response_entity.dart';

class ResponseModel {
  final bool success;

  ResponseModel({required this.success});

  factory ResponseModel.fromJson(bool json) {
    return ResponseModel(
      success: json,
    );
  }

  ResponseEntity toEntity() {
    return ResponseEntity(isSuccess: success);
  }
}
