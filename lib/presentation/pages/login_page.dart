import 'package:firebase_auth_demo/presentation/blocs/auth_cubit.dart';
import 'package:firebase_auth_demo/presentation/blocs/auth_state.dart';
import 'package:firebase_auth_demo/presentation/pages/change_password_page.dart';
import 'package:firebase_auth_demo/presentation/pages/signup_page.dart';
import 'package:firebase_auth_demo/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:food_pick/presentation/pages/change_password_page.dart';
// import 'package:food_pick/presentation/pages/main_page.dart';
// import 'package:food_pick/presentation/pages/signup_page.dart';
// import 'package:food_pick/utils/navigation_util.dart';
// import '../../presentation/blocs/auth/auth_cubit.dart';
// import '../blocs/auth/auth_state.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(

        // ),
        // appBar: Container(child: ,),
        body: LoginScreen()
        // BlocListener<AuthCubit, AuthState>(
        //   listener: (context, state) {
        //     print("login page");
        //     // if (state is AuthAuthenticated) {
        //     //   Navigator.of(context).pushReplacement(
        //     //     MaterialPageRoute(builder: (_) => MainPage()),
        //     //   );
        //     // }
        //     if (state is AuthError) {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         SnackBar(content: Text(state.message)),
        //       );
        //     }
        //   },
        //   child: LoginScreen(),
        // ),
        );
  }
}

class LoginScreen extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("login screen");
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        print("BlocListenerBlocListener");
        print(state);
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("아이디와 비밀번호가 일치하지 않습니다")),
            // SnackBar(content: Text(state.message)),
          );
        }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('${state.props[0]}')),
        // );
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
                SizedBox(height: 8),
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
                    // Navigator.pushNamed(context, '/main');
                    // context.read<AuthCubit>().gestLogin();
                  },
                  icon: Icon(Icons.person_outline),
                  label: Text(
                    '로그인 없이 바로 PICK!',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    // primary: Color(0xFFFB9A79),
                    backgroundColor: Color(0xFFFB9A79),
                    onPrimary: Colors.white,
                    minimumSize: Size(
                      300,
                      60,
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
                      300,
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: _buildLinkRow(),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Text('아이디찾기'),
                      onTap: () => {print("hello")},
                    ),
                    SizedBox(width: 8),
                    Text('|'),
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
                SizedBox(height: 32),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     // 네이버 아이콘
                //     ClipOval(
                //       child: SizedBox(
                //         width: 50, // 너비를 10으로 설정
                //         height: 50, // 높이를 10으로 설정
                //         child: Image.network(
                //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNbUL0znlFSc0VXnXcsda4ho3DLV4Crgb3wQ&s',
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 20), // 간격 설정

                //     // 카카오 아이콘
                //     ClipOval(
                //       child: SizedBox(
                //         width: 50, // 너비를 10으로 설정
                //         height: 50, // 높이를 10으로 설정
                //         child: Image.network(
                //           'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQNbUL0znlFSc0VXnXcsda4ho3DLV4Crgb3wQ&s',
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //     ),
                //     SizedBox(width: 20), // 간격 설정
                //     // Text('Welcome, ${state}!'),
                //     // 구글 아이콘
                //     GestureDetector(
                //       onTap: () {},
                //       child: ClipOval(
                //         child: SizedBox(
                //           width: 50, // 너비를 10으로 설정
                //           height: 50, // 높이를 10으로 설정
                //           child: Image.network(
                //             'https://static-00.iconduck.com/assets.00/google-icon-512x512-yk2xx8br.png',
                //             fit: BoxFit.cover,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                // Divider(),
                // SizedBox(height: 16),
                // Text('다른 방법으로 로그인'),
                // SizedBox(height: 16),
                // ElevatedButton.icon(
                //   onPressed: () {
                //     context.read<AuthCubit>().signInWithGoogle(
                //         // _usernameController.text,
                //         // _passwordController.text,
                //         );
                //   },
                //   icon: Image.network(
                //     'https://static-00.iconduck.com/assets.00/google-icon-512x512-tqc9el3r.png',
                //     width: 24,
                //     height: 24,
                //   ),
                //   label: Text('Google로 시작하기'),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.white,
                //     onPrimary: Colors.black,
                //     minimumSize: Size(double.infinity, 48),
                //     side: BorderSide(color: Colors.grey),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(
                //           10.0), // 버튼의 모서리 반경을 20.0으로 설정합니다.
                //     ),
                //   ),
                // ),
                // SizedBox(height: 16),
                // ElevatedButton.icon(
                //   onPressed: () {},
                //   icon: Icon(Icons.person_outline),
                //   label: Text('Guest로 시작하기'),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.white,
                //     onPrimary: Colors.black,
                //     minimumSize: Size(double.infinity, 48),
                //     side: BorderSide(color: Colors.grey),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(
                //           10.0), // 버튼의 모서리 반경을 20.0으로 설정합니다.
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../auth_state.dart';
// import '../../presentation/blocs/auth/auth_cubit.dart';
// import '../blocs/auth/auth_state.dart';
// import 'main_page.dart';

// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           // title: Text('Login')

//           ),
//       body: BlocListener<AuthCubit, AuthState>(
//           listener: (context, state) {
//             if (state is Authenticated) {
//               Navigator.of(context).pushReplacement(
//                 MaterialPageRoute(builder: (_) => MainPage()),
//               );
//             } else if (state is AuthError) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.message)),
//               );
//             }
//           },
//           child: LoginScreen()

//           // Padding(
//           //   padding: EdgeInsets.all(16.0),
//           //   child: Column(
//           //     mainAxisAlignment: MainAxisAlignment.center,
//           //     children: [
//           //       TextField(
//           //         controller: _usernameController,
//           //         decoration: InputDecoration(labelText: 'Username'),
//           //       ),
//           //       TextField(
//           //         controller: _passwordController,
//           //         decoration: InputDecoration(labelText: 'Password'),
//           //         obscureText: true,
//           //       ),
//           //       SizedBox(height: 16),
//           //       ElevatedButton(
//           //         onPressed: () {
//           //           context.read<AuthCubit>().login(
//           //                 _usernameController.text,
//           //                 _passwordController.text,
//           //               );
//           //         },
//           //         child: Text('Login'),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//           ),
//     );
//   }
// }

// class LoginScreen extends StatelessWidget {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               '오늘의 메뉴, 고민 끝!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               '푸드픽에서 단, 3초면 OK!!',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//             ),
//             SizedBox(height: 32),
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(
//                     color: Colors.grey, // 활성화된 상태의 테두리 색상
//                     width: 10.0, // 활성화된 상태의 테두리 두께
//                   ),
//                   borderRadius:
//                       BorderRadius.circular(20.0), // 여기서 16.0은 둥근 모서리의 반지름입니다.
//                 ),
//                 labelText: '이메일 입력.',
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: '비밀번호 입력',
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 context.read<AuthCubit>().login(
//                       _usernameController.text,
//                       _passwordController.text,
//                     );
//               },
//               style: ElevatedButton.styleFrom(
//                 primary: Color(0xFFFF6B6B),
//                 minimumSize: Size(double.infinity, 48),
//               ),
//               child: Text('로그인'),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('아이디찾기'),
//                 SizedBox(width: 8),
//                 Text('|'),
//                 SizedBox(width: 8),
//                 Text('비밀번호찾기'),
//                 SizedBox(width: 8),
//                 Text('|'),
//                 SizedBox(width: 8),
//                 Text('회원가입'),
//               ],
//             ),
//             SizedBox(height: 32),
//             Divider(),
//             SizedBox(height: 16),
//             Text('다른 방법으로 로그인'),
//             SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: () {},
//               icon: Image.network(
//                 'https://static-00.iconduck.com/assets.00/google-icon-512x512-tqc9el3r.png',
//                 width: 24,
//                 height: 24,
//               ),
//               label: Text('Google로 시작하기'),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.white,
//                 onPrimary: Colors.black,
//                 minimumSize: Size(double.infinity, 48),
//                 side: BorderSide(color: Colors.grey),
//               ),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.person_outline),
//               label: Text('Guest로 시작하기'),
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.white,
//                 onPrimary: Colors.black,
//                 minimumSize: Size(double.infinity, 48),
//                 side: BorderSide(color: Colors.grey),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
