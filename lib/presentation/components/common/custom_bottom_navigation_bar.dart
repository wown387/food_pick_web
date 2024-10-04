// common_widgets.dart 파일을 새로 생성해서 공통 위젯을 정의합니다.
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // 원하는 높이로 설정
      width: double.infinity, // 너비를 화면 전체로 설정
      child: BottomNavigationBar(
         type: BottomNavigationBarType.fixed, // 아이템 간의 간격이 고정되도록 설정
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                color: currentIndex == 0 ? Colors.orange : Colors.grey),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,
                color: currentIndex == 1 ? Colors.orange : Colors.grey),
            label: '실시간 푸드',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.update,
                color: currentIndex == 2 ? Colors.orange : Colors.grey),
            label: '업데이트 중',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
                color: currentIndex == 3 ? Colors.orange : Colors.grey),
            label: '나의푸드',
          ),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: onTap,
      ),
    );
  }
}
