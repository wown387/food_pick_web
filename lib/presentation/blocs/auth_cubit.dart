import 'package:dartz/dartz.dart';
import 'package:firebase_auth_demo/core/errors/failures.dart';
import 'package:firebase_auth_demo/data/models/user_model.dart';
import 'package:firebase_auth_demo/domain/usecases/auth/login_usecase.dart';
import 'package:firebase_auth_demo/domain/usecases/auth/logout_usecase.dart';
import 'package:firebase_auth_demo/domain/usecases/auth/signup_usecase.dart';
import 'package:firebase_auth_demo/domain/usecases/system_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

// enum LoginType { google, normal,guest }

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final SignupUseCase signupUseCase;
  final SystemRequestUseCase systemRequestUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.signupUseCase,
    required this.systemRequestUseCase,
  }) : super(Unauthenticated());

  // Future<void> checkAuth() async {
  //   final token = await signupUseCase.isAuthToken();
  //   if (token) {
  //     try {
  //       // 토큰 유효성 검사 API 호출
  //       // final isValid = await signupUseCase.validateToken(token);
  //       final isValid = true;
  //       if (isValid) {
  //         emit(AuthAuthenticated());
  //       } else {
  //         emit(Unauthenticated());
  //       }
  //     } catch (e) {
  //       emit(Unauthenticated());
  //     }
  //   } else {
  //     emit(Unauthenticated());
  //   }
  // }

  Future<void> gestLogin() async {
    emit(AuthLoading());
    final result = await loginUseCase("", "", LoginType.guest);
    print(result);
    print("getLogingetLogingetLogin");
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> login(String username, String password) async {
    emit(AuthLoading());
    final result = await loginUseCase(username, password, LoginType.normal);
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> signUp(Map<String, dynamic> body) async {
    print("signUp cubit start");
    emit(AuthLoading());
    // Either<Failure, UserModel> result = await signupUseCase(body);
    print("signUp cubit start");
    final result = await signupUseCase.regist(body);
    print("asdfasfasfasdfasdf");
    print("signUpsignUpsignUpsignUp ${result}");
    print(result);
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(AuthRegistered()),
    );
  }

  Future<void> logout() async {
    try {
      // 로그아웃 로직
      print('Logout process started');
      await logoutUseCase();
      emit(Unauthenticated());

      print('Emitted Unauthenticated state');
    } catch (e) {
      print('Error during logout: $e');
      // emit(AuthError('Logout failed'));
    }
    // print('Logout attempt');
    // emit(AuthLoading());
    // final result = await logoutUseCase();
    // result.fold(
    //   (failure) {
    //     print('Logout failed: ${failure.toString()}');
    //     emit(AuthError(message: 'Logout failed'));
    //   },
    //   (_) {
    //     print('Logout successful');
    //     emit(Unauthenticated());
    //   },
    // );
    // print('Current state after logout attempt: ${state.runtimeType}');
  }

  Future<void> checkAuthStatus() async {
    // 여기서 저장된 토큰이나 세션을 확인하여 인증 상태를 결정합니다.
    // 예를 들어:
    // final token = await _getStoredToken();
    // if (token != null) {
    //   emit(Authenticated(user: User(...)));
    // } else {
    //   emit(Unauthenticated());
    // }
  }
}
