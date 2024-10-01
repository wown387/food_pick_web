// lib/presentation/pages/profile_page.dart
import 'package:firebase_auth_demo/presentation/blocs/auth_cubit.dart';
import 'package:firebase_auth_demo/presentation/blocs/auth_state.dart';
import 'package:firebase_auth_demo/presentation/layouts/main_layout.dart';
import 'package:firebase_auth_demo/presentation/pages/setting_page.dart';
import 'package:firebase_auth_demo/utils/custom_date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(context.read<AuthCubit>());
    return MainLayout(
        currentIndex: 3, // BottomNavigationBar의 현재 선택된 인덱스 설정
        child: ProfileScreen());
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isPasswordChangeVisible = false;
  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      SettingPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child; // 전환 애니메이션 없이 페이지를 표시합니다.
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        if (state is Unauthenticated ||
            (state is AuthAuthenticated && state.user?.sex == null)) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Text('로그인 하러 가기'),
            ),
          );
        } else if (state is AuthAuthenticated) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(40),
                          image: const DecorationImage(
                            image: NetworkImage(
                                'https://fastly.picsum.photos/id/501/200/300.jpg?hmac=fk5fWXapclFoDmPlQjOTEHRG3uPBJuPmB_5HeJsEsfY'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${state.user.username}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  buildProfileItem('이 메 일', '${state.user.email}'),
                  buildProfileItem('생년월일',
                      CustomDateUtils.formatDate('${state.user.birth}')),
                  buildProfileItem('성 별', '${state.user.sex}'),
                  const SizedBox(height: 32),
                  const Divider(),
                  // buildProfileItem('비밀번호 변경', ''),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordChangeVisible =
                              !_isPasswordChangeVisible; // 클릭 시 폼을 표시하거나 숨김
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "비밀번호 변경",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.chevron_right), // 일반적인 오른쪽 화살표
                        ],
                      ),
                    ),
                  ),
                  const Divider(),

                  if (_isPasswordChangeVisible) ...[
                    buildPasswordField('기존 비밀번호', _currentPasswordController),
                    const Divider(),
                    buildPasswordField('새로운 비밀번호', _newPasswordController),
                    const Divider(),
                    buildPasswordField('비밀번호 재입력', _confirmPasswordController),
                    const Divider(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        // 비밀번호 변경 로직 추가
                        final result = await context
                            .read<AuthCubit>()
                            .signupUseCase
                            .changePassword({
                          "newPassword": _newPasswordController.text,
                          "prevPassword": _currentPasswordController.text,
                        });
                        print("checkDuplicate ${result.isSuccess}");
                        if (result.isSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('비밀번호 변경이 완료되었습니다')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('비밀번호 변경에 실패하였습니다')),
                          );
                        }
                        print('기존 비밀번호: ${_currentPasswordController.text}');
                        print('새로운 비밀번호: ${_newPasswordController.text}');
                        print('비밀번호 재입력: ${_confirmPasswordController.text}');
                      },
                      child: Text('비밀번호 변경'),
                    ),
                  ],
                ],
              ),
            ),
          );
        } else {
          return Text("page error");
        }
      }),
    );
  }

  Widget buildPasswordField(String label, TextEditingController controller) {
    return Container(
      height: 40, // 입력창 높이 설정
      child: TextField(
        controller: controller,

        obscureText: true, // 비밀번호 입력을 숨김 처리
        decoration: InputDecoration(
          isDense: true, // 공간을 줄이기 위한 설정
          border: InputBorder.none, // 테두리 제거
          hintText: label, // 입력창 안에 힌트 텍스트
        ),
        style: TextStyle(fontSize: 16), // 텍스트 크기 줄이기
      ),
    );
  }

  Widget buildProfileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
