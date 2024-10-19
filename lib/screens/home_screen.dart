import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // 카메라 화면으로 이동
                Navigator.of(context).pushNamed('/camera');
              },
              child: const Text('Go to Camera Screen'),
            ),
            const SizedBox(height: 20), // 버튼 사이 간격 추가
            ElevatedButton(
              onPressed: () {
                // New Button을 눌렀을 때 하단에 메시지를 보여줌
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('New Button Pressed!'),
                  ),
                );
              },
              child: const Text('New Button'),
            ),
          ],
        ),
      ),
    );
  }
}
