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
        child: ElevatedButton(
          onPressed: () {
            // 카메라 화면으로 이동
            Navigator.of(context).pushNamed('/camera');
          },
          child: const Text('Go to Camera Screen'),
        ),
      ),
    );
  }
}
