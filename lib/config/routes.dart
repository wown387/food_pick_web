import 'package:firebase_auth_demo/presentation/blocs/auth_cubit.dart';
import 'package:firebase_auth_demo/presentation/blocs/auth_state.dart';
import 'package:firebase_auth_demo/presentation/pages/login_page.dart';
import 'package:firebase_auth_demo/presentation/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) {
            // 이전 상태와 현재 상태가 다른 경우에만 리스너 실행
            return previous != current;
          },
          listener: (context, state) {
            print("route blocListener ${state}");
            if (state is AuthAuthenticated) {
              Navigator.of(context).pushReplacementNamed('/main');
            } else if (state is Unauthenticated) {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
          child: _getPageForRoute(settings),
        );
      },
    );
  }

  static Widget _getPageForRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            print("_getPageForRoute ${state} ${settings.name}");
            if (state is AuthAuthenticated) {
              return MainPage();
            } else {
              return LoginPage();
            }
          },
        );
      case '/login':
        return LoginPage();
      case '/main':
        return MainPage();
      default:
        return Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        );
    }
  }
}
