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
            } else {
              print("hello!!");
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

// class SettingsItem extends StatelessWidget {
//   final String title;

//   const SettingsItem({required this.title, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         ListTile(
//           title: Text(title),
//         ),
//         const Divider(
//           height: 1,
//           color: Colors.grey,
//         ),
//       ],
//     );
//   }
// }
