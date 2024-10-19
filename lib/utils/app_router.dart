import 'package:go_router/go_router.dart';
import 'package:nutripic/screens/camera_screen.dart';
import 'package:nutripic/screens/home_screen.dart';

class AppRouter {
  static GoRouter getRouter() {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/camera',
          builder: (context, state) => const CameraScreen(), // CameraScreen 추가
        ),
      ],
    );
  }
}
