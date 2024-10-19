import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.teal, // 앱바 색상 변경
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 카메라 버튼
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/camera');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // 버튼 색상
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 20), // 버튼 패딩
                textStyle: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold), // 텍스트 스타일
              ),
              child: const Text('Go to Camera Screen'),
            ),
            const SizedBox(height: 30), // 버튼 사이 간격 추가
            // 새 버튼
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('New Button Pressed!'),
                    duration: Duration(seconds: 2), // 메시지 표시 시간
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber, // 다른 색상의 버튼
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 20), // 버튼 패딩
                textStyle: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold), // 텍스트 스타일
              ),
              child: const Text('New Button'),
            ),
          ],
        ),
      ),
      // 하단에 아이콘 추가
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 다른 동작을 위한 기능 추가 가능
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Floating Action Button Pressed!'),
            ),
          );
        },
        child: const Icon(Icons.add), // 아이콘
        backgroundColor: Colors.teal, // 플로팅 버튼 색상
      ),
    );
  }
}
