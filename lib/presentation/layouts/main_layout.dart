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
              Navigator.pushReplacement(
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
              Navigator.pushReplacement(
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('준비 중입니다.')),
              );
              // Navigator.push(
              //   context,
              //   PageRouteBuilder(
              //     pageBuilder: (context, animation, secondaryAnimation) =>
              //         UpdatePage(),
              //     transitionsBuilder:
              //         (context, animation, secondaryAnimation, child) {
              //       return child; // 전환 애니메이션 없이 페이지를 표시합니다.
              //     },
              //   ),
              //   // MaterialPageRoute(builder: (context) => ProfilePage()),
              // );
            } else if (index == 3) {
              Navigator.pushReplacement(
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

// import 'package:firebase_auth_demo/presentation/components/common/custom_bottom_navigation_bar.dart';
// import 'package:firebase_auth_demo/presentation/pages/main_page.dart';
// import 'package:firebase_auth_demo/presentation/pages/profile_page.dart';
// import 'package:firebase_auth_demo/presentation/pages/trending_food_page.dart';
// import 'package:firebase_auth_demo/presentation/pages/update_page.dart';
// import 'package:flutter/material.dart';

// class MainLayout extends StatefulWidget {
//   final int currentIndex;

//   const MainLayout({
//     Key? key,
//     this.currentIndex = 0,
//   }) : super(key: key);

//   @override
//   State<MainLayout> createState() => _MainLayoutState();
// }

// class _MainLayoutState extends State<MainLayout> {
//   late int _selectedIndex;
//   late List<Widget> _pages;

//   @override
//   void initState() {
//     super.initState();
//     _selectedIndex = widget.currentIndex;
//     _pages = [
//       MainPage(),
//       TrendingFoodPage(),
//       Placeholder(), // 준비 중인 페이지
//       ProfilePage(),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: null,
//       body: SafeArea(
//         child: IndexedStack(
//           index: _selectedIndex,
//           children: _pages,
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           if (index == 2) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('준비 중입니다.')),
//             );
//           } else {
//             setState(() {
//               _selectedIndex = index;
//             });
//           }
//         },
//       ),
//     );
//   }
// }
