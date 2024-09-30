import 'package:equatable/equatable.dart';
import '../../../domain/entities/auth/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class Unauthenticated extends AuthState {}

class AuthLoading extends AuthState {}

// class Authenticated extends AuthState {
//   final User user;

//   Authenticated({required this.user});

//   @override
//   List<Object> get props => [user];
// }

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthRegistered extends AuthState {}

// class AuthAuthenticated extends AuthState {
//   final User user;
//   final Food? food; // Food를 선택적으로 만듭니다.

//   const AuthAuthenticated({
//     required this.user,
//     this.food, // food는 선택적 매개변수로 만듭니다.
//   });

//   @override
//   List<Object?> get props => [user, food];
// }
