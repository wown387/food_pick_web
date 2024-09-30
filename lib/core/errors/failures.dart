import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List properties;

  const Failure([this.properties = const <dynamic>[]]);

  @override
  List<Object> get props => [properties];
}

// 서버 관련 실패
class ServerFailure extends Failure {
  final String? message;

  ServerFailure({this.message});

  @override
  List<Object> get props => [message ?? ''];
}

// 네트워크 연결 실패
class NetworkFailure extends Failure {
  final String? message;

  NetworkFailure({this.message});

  @override
  List<Object> get props => [message ?? ''];
}

// 캐시 관련 실패
class CacheFailure extends Failure {
  final String? message;

  CacheFailure({this.message});

  @override
  List<Object> get props => [message ?? ''];
}

// 인증 실패
class AuthenticationFailure extends Failure {
  final String? message;

  AuthenticationFailure({this.message});

  @override
  List<Object> get props => [message ?? ''];
}

// 입력 유효성 검사 실패
class ValidationFailure extends Failure {
  final String? field;
  final String? message;

  ValidationFailure({this.field, this.message});

  @override
  List<Object> get props => [field ?? '', message ?? ''];
}

// 권한 부족 실패
class PermissionFailure extends Failure {
  final String? message;

  PermissionFailure({this.message});

  @override
  List<Object> get props => [message ?? ''];
}

// 알 수 없는 실패
class UnknownFailure extends Failure {
  final String? message;

  UnknownFailure({this.message});

  @override
  List<Object> get props => [message ?? ''];
}
