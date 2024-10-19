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
                // 새로운 버튼 기능
                print("New Button Pressed");
              },
              child: const Text('New Button'),
            ),
          ],
        ),
      ),
    );
  }
}
