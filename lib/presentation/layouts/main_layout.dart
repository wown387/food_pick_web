import 'package:firebase_auth_demo/presentation/components/common/custom_bottom_navigation_bar.dart';
import 'package:firebase_auth_demo/presentation/pages/main_page.dart';
import 'package:firebase_auth_demo/presentation/pages/profile_page.dart';
import 'package:firebase_auth_demo/presentation/pages/trending_food_page.dart';
import 'package:firebase_auth_demo/presentation/pages/update_page.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainLayout({
    Key? key,
    required this.child,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      // appBar: AppBar(
      //     // title: Text('App Title'),
      //     // actions: [
      //     //   IconButton(
      //     //     icon: Icon(Icons.exit_to_app),
      //     //     onPressed: () {
      //     //       // 로그아웃 로직
      //     //     },
      //     //   ),
      //     // ],
      //     ),
      body: SafeArea(
        child: widget.child,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: (index) {
            // 네비게이션 로직
            setState(() {
              _selectedIndex = index;
            });
            if (index == 0) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      MainPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child; // 전환 애니메이션 없이 페이지를 표시합니다.
                  },
                ),
                // MaterialPageRoute(builder: (context) => MainPage()),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      TrendingFoodPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child; // 전환 애니메이션 없이 페이지를 표시합니다.
                  },
                ),
                // MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      UpdatePage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child; // 전환 애니메이션 없이 페이지를 표시합니다.
                  },
                ),
                // MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            } else if (index == 3) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      ProfilePage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return child; // 전환 애니메이션 없이 페이지를 표시합니다.
                  },
                ),
                // MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            }
          }),
    );
  }
}
