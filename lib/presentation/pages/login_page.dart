import 'package:firebase_auth_demo/presentation/blocs/auth_cubit.dart';
import 'package:firebase_auth_demo/presentation/blocs/auth_state.dart';
import 'package:firebase_auth_demo/presentation/pages/change_password_page.dart';
import 'package:firebase_auth_demo/presentation/pages/signup_page.dart';
import 'package:firebase_auth_demo/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: LoginScreen());
//   }
// }
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoginScreen());
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("login screen");
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) {
        // 이전 상태와 현재 상태가 다른 경우에만 true를 반환
        return previous != current;
      },
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("아이디와 비밀번호가 일치하지 않습니다")),
          );
        }
      },
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '오늘의 메뉴, 고민 끝!',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '푸드픽에서 단, 3초면 OK!!',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<AuthCubit>().gestLogin();
                  },
                  icon: Icon(Icons.person_outline),
                  label: Text(
                    '로그인 없이 바로 PICK!',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFB9A79),
                    onPrimary: Colors.white,
                    minimumSize: Size(
                      310,
                      50,
                    ),
                    side: BorderSide(color: const Color(0xFFFB9A79)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // 버튼의 모서리 반경을 20.0으로 설정합니다.
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: Colors.grey, // 선 색상 설정
                        thickness: 1, // 선 두께 설정
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        '다른 방법으로 로그인', // 중앙 텍스트
                        style: TextStyle(
                          fontSize: 14, // 글자 크기
                          fontWeight: FontWeight.bold, // 글자 굵기
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey, // 선 색상 설정
                        thickness: 1, // 선 두께 설정
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelText: '이메일 입력',
                    ),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelText: '비밀번호 입력',
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().login(
                          _usernameController.text,
                          _passwordController.text,
                        );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFB9A79),
                    minimumSize: Size(
                      310,
                      50,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          8.0), // 버튼의 모서리 반경을 20.0으로 설정합니다.
                    ),
                  ),
                  child: Text(
                    '로그인',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 8),
                    GestureDetector(
                      child: Text('비밀번호찾기'),
                      onTap: () {
                        navigateWithoutAnimation(context, ChangePasswordPage());
                      },
                    ),
                    SizedBox(width: 8),
                    Text('|'),
                    SizedBox(width: 8),
                    GestureDetector(
                      child: Text('회원가입'),
                      onTap: () {
                        navigateWithoutAnimation(context, SignupPage());
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
