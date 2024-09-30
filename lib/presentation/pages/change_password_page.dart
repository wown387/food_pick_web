import 'package:firebase_auth_demo/presentation/blocs/auth_cubit.dart';
import 'package:firebase_auth_demo/presentation/blocs/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: ChangePasswordScreen()));
  }
}

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isCodeSent = false; // 인증코드 전송 여부를 확인하는 변수

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 인증코드 요청 함수
  void _requestCode() async {
    if (_emailController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('올바른 이메일을 입력해주세요')),
      );
      return;
    }
    final result = await context
        .read<AuthCubit>()
        .signupUseCase
        .requestPasswordReset(_emailController.text);
    // 여기에 이메일로 인증코드를 보내는 로직을 구현합니다.
    print("인증코드 수신 여부 ${result.isSuccess}");
    if (result.isSuccess == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일 요청에 실패하였습니다')),
      );
      return;
    }
    setState(() {
      isCodeSent = true;
    });
    print('인증코드 요청: ${_emailController.text}');
  }

  // 비밀번호 변경 함수
  void _changePassword() async {
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      // 비밀번호와 재입력된 비밀번호가 다르면 에러 메시지 출력
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비밀번호가 일치하지 않습니다.')),
      );
      return;
    }
    final body = {
      "code": _codeController.text,
      "email": _emailController.text,
      "password": newPassword
    };
    final result = await context
        .read<AuthCubit>()
        .signupUseCase
        .validatePasswordReset(body);
    // 여기에 비밀번호를 변경하는 로직을 구현합니다.
    print("비밀번호 변경 성공 여부 ${result.isSuccess}");
    if (result.isSuccess) {
      showDialog(
        context: context,
        barrierDismissible: false, // 사용자가 다이얼로그 바깥을 터치해도 닫히지 않도록 설정
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('비밀번호 변경 완료'),
            content: Text('비밀번호가 성공적으로 변경되었습니다.'),
            actions: <Widget>[
              TextButton(
                child: Text('확인'),
                onPressed: () {
                  // 다이얼로그를 닫습니다.
                  Navigator.of(context).pop();

                  // 로그인 페이지로 네비게이션합니다.
                  // 'LoginPage'를 실제 로그인 페이지의 라우트 이름으로 변경하세요.
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login', (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        },
      );
    } else {
      // 비밀번호 변경 실패 시 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('비밀번호 변경에 실패했습니다. 다시 시도해주세요.')),
      );
    }
    print(
        '이메일: ${_emailController.text} 인증코드: ${_codeController.text} 비밀번호 변경 요청: 새 비밀번호: $newPassword');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "비밀번호 변경",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: '이 메 일',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _requestCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          '요청하기',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _codeController,
                          decoration: const InputDecoration(
                            labelText: '인증코드',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: UnderlineInputBorder(),
                          ),
                          enabled: isCodeSent, // 인증코드 입력란은 인증코드 요청 후에 활성화
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _newPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: '새로운 비밀번호',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: '비밀번호 재입력',
                      labelStyle: TextStyle(color: Colors.grey),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFB9A79),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '변경완료',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ));
        });
  }
}



// import 'package:flutter/material.dart';

// class ChangePasswordPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(body: SafeArea(child: ChangePasswordScreen()));
//   }
// }

// class ChangePasswordScreen extends StatelessWidget {
//   const ChangePasswordScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "비밀번호 변경",
//               style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             const TextField(
//               decoration: InputDecoration(
//                 labelText: '이 메 일',
//                 labelStyle: TextStyle(color: Colors.grey),
//                 border: UnderlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: const TextField(
//                     decoration: InputDecoration(
//                       labelText: '인증코드',
//                       labelStyle: TextStyle(color: Colors.grey),
//                       border: UnderlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: () {},
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.grey,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                   ),
//                   child: const Text(
//                     '요청하기',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             const TextField(
//               decoration: InputDecoration(
//                 labelText: '새로운 비밀번호',
//                 labelStyle: TextStyle(color: Colors.grey),
//                 border: UnderlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             const TextField(
//               decoration: InputDecoration(
//                 labelText: '비밀번호 재입력',
//                 labelStyle: TextStyle(color: Colors.grey),
//                 border: UnderlineInputBorder(),
//               ),
//             ),
//             const Spacer(),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFFFB9A79),
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 16,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: const Text(
//                   '변경완료',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }
// }
