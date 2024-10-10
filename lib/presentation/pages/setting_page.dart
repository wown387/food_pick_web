import 'package:firebase_auth_demo/presentation/blocs/auth_cubit.dart';
import 'package:firebase_auth_demo/presentation/blocs/auth_state.dart';
import 'package:firebase_auth_demo/presentation/layouts/main_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 3,
      child: SettingScreen(),
    );
  }
}

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      if (state is AuthAuthenticated) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "설정",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SettingsItem(
                  title: '공지사항',
                  url:
                      "https://parallel-jodhpur-935.notion.site/10d2c71ec7c580adb0acf7b0f2152ed6",
                ),
                SettingsItem(title: '의견 보내기'),
                SettingsItem(
                  title: '서비스 이용 약관',
                  url:
                      "https://parallel-jodhpur-935.notion.site/10d2c71ec7c580adb0acf7b0f2152ed6",
                ),
                SettingsItem(
                  title: '개인정보처리방침',
                  url:
                      "https://parallel-jodhpur-935.notion.site/10d2c71ec7c580e1bba8c16dd448a94b",
                ),
                SettingsItem(title: '버전정보    V1.0'),
                state.user.id == -1 ? Container() : SettingsItem(title: '로그아웃'),
                state.user.id == -1
                    ? Container()
                    : SettingsItem(title: '회원 탈퇴'),
              ],
            ),
          ),
        );
      } else {
        return Text("setting page error");
      }
    });
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final String? url;

  SettingsItem({
    required this.title,
    this.url,
    Key? key,
  }) : super(key: key);

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          // onTap: url != null ? () => _launchURL : null,
          onTap: () async {
            if (title == "로그아웃") {
              context.read<AuthCubit>().logout();
            } else if (title == "의견 보내기") {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return FeedbackModal();
                },
              );
              if (url != null) {
                _launchURL(url!);
              }
            } else if (title == "회원 탈퇴") {
              final result =
                  await context.read<AuthCubit>().signupUseCase.deleteUser();
              print("회원 탈퇴 result ${result}");
              if (result.isSuccess) {
                showDeleteAccountModal(context);
              } else {
                SnackBar(content: Text("회원 탈퇴에 실패하였습니다"));
              }
            } else {
              if (url != null) {
                _launchURL(url!);
              }
            }
          },
          trailing: url != null ? Icon(Icons.arrow_forward_ios) : null,
        ),
        const Divider(
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}

void showDeleteAccountModal(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // 사용자가 다이얼로그 바깥을 터치해도 닫히지 않도록 설정
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('회원 탈퇴'),
        content: Text('회원 탈퇴가 완료 되었습니다.'),
        actions: <Widget>[
          TextButton(
            child: Text('확인'),
            onPressed: () {
              // 다이얼로그를 닫습니다.
              Navigator.of(context).pop();

              // 로그인 페이지로 네비게이션합니웃다.
              // 'LoginPage'를 실제 로그인 페이지의 라우트 이름으로 변경하세요.
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', (Route<dynamic> route) => false);
            },
          ),
        ],
      );
    },
  );
}

class FeedbackModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '의견 보내기',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '의견을 입력하세요',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('취소'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    String feedback = feedbackController.text;
                    if (feedback.isNotEmpty) {
                      // 의견 처리 로직 추가 (예: 서버로 전송)
                      final result = await context
                          .read<AuthCubit>()
                          .systemRequestUseCase
                          .report({"reason": feedback});
                      print("request report ${result}");
                      // context[]
                      //     .read<S>()

                      Navigator.of(context).pop(); // 모달 닫기

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('의견이 성공적으로 전송되었습니다!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('의견을 입력해 주세요.'),
                        ),
                      );
                    }
                  },
                  child: Text('보내기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
