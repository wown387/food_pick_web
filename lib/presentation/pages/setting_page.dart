import 'package:firebase_auth_demo/presentation/blocs/auth_cubit.dart';
import 'package:firebase_auth_demo/presentation/layouts/main_layout.dart';
import 'package:firebase_auth_demo/utils/navigation_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(context.read<AuthCubit>());
    return MainLayout(
      currentIndex: 3, // BottomNavigationBar의 현재 선택된 인덱스 설정
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "설정",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          // backgroundColor: Colors.white,
          // elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Text("hello"),
              // SettingsItem(title: '알림 설정'),
              SettingsItem(
                title: '공지사항',
                url:
                    "https://parallel-jodhpur-935.notion.site/10d2c71ec7c580adb0acf7b0f2152ed6",
              ),
              // SettingsItem(title: '자주 묻는 질문'),
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
              SettingsItem(title: '버전정보    V24.9.0'),
              SettingsItem(title: '로그아웃')
            ],
          ),
        ),
      ),
    );
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
    html.window.open(url, '_blank'); // 새 창에서 URL 열기
    // if (!await launchUrl(
    //   uri,
    //   mode: LaunchMode.externalApplication,
    // )) {
    //   throw Exception('Could not launch $url');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          // onTap: url != null ? () => _launchURL : null,
          onTap: () {
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
                          .report({"reson": feedback});
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
