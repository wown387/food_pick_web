import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// 페이지 전환 애니메이션 없이 새로운 페이지로 이동하는 함수.
///
/// [context]: 현재 빌드 컨텍스트.
/// [page]: 이동할 페이지의 위젯.
///
///

Future<void> launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  launchUrl(uri);
  // if (!await launchUrl(uri)) {
  //   throw Exception('Could not launch $url');
  // }
}

void navigateWithoutAnimation(BuildContext context, Widget page) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child; // 전환 애니메이션 없이 페이지를 표시합니다.
      },
    ),
  );
}

/// 전환 애니메이션과 함께 새로운 페이지로 이동하는 함수.
///
/// [context]: 현재 빌드 컨텍스트.
/// [page]: 이동할 페이지의 위젯.
/// [duration]: 애니메이션의 지속 시간. 기본값은 300ms.
void navigateWithAnimation(BuildContext context, Widget page,
    {Duration duration = const Duration(milliseconds: 300)}) {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0); // 오른쪽에서 왼쪽으로 슬라이드
        var end = Offset.zero;
        var curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: duration,
    ),
  );
}

/// 현재 페이지를 종료하고 이전 페이지로 돌아가는 함수.
void popPage(BuildContext context) {
  Navigator.pop(context);
}
