import 'package:firebase_auth_demo/presentation/layouts/main_layout.dart';
import 'package:flutter/material.dart';

class UpdatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      currentIndex: 2, // BottomNavigationBar의 현재 선택된 인덱스 설정
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Page...',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
