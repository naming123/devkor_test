import 'package:flutter/material.dart';
import 'package:nutripic/utils/app_router.dart'; // AppRouter import
import 'package:camera/camera.dart';
import 'package:flutter_vision/flutter_vision.dart';

// 카메라 및 YOLO 모델 사용을 위한 변수 설정
List<CameraDescription> cameras = [];
FlutterVision vision = FlutterVision();

void main() async {
  // 카메라 사용 전 Flutter 엔진 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 사용 가능한 카메라 목록을 가져오기
  cameras = await availableCameras();

  runApp(MainApp());
}

// AppRouter 인스턴스 가져오기
final _router = AppRouter.getRouter();

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutripic',
      debugShowCheckedModeBanner: false,
      // 기본 라우트를 설정
      initialRoute: '/',
      // 명명된 라우트 설정
      routes: {
        '/': (context) => HomeScreen(), // 홈 화면 경로
        '/camera': (context) => const CameraScreen(), // 카메라 화면 경로
      },
    );
  }
}

// 홈 화면 위젯 (카메라 화면으로 전환 버튼 포함)
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutripic Home'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 카메라 화면으로 이동
            Navigator.pushNamed(context, '/camera');
          },
          child: const Text('Go to Camera'),
        ),
      ),
    );
  }
}

// 객체 감지를 위한 카메라 화면
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    // 카메라 초기화 및 YOLO 모델 로드
    _initializeCamera();
    _loadYoloModel();
  }

  Future<void> _initializeCamera() async {
    _controller = CameraController(cameras[0], ResolutionPreset.high);
    await _controller.initialize();
    setState(() {}); // 카메라가 초기화되면 화면을 다시 빌드

    // 카메라 프레임을 실시간으로 처리
    _controller.startImageStream((CameraImage cameraImage) async {
      if (!_isDetecting) {
        _isDetecting = true;

        // YOLOv8 모델로 객체 감지 수행
        final result = await vision.yoloOnFrame(
            bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
            imageHeight: cameraImage.height,
            imageWidth: cameraImage.width,
            iouThreshold: 0.4, // 겹침 임계값
            confThreshold: 0.4, // 신뢰도 임계값
            classThreshold: 0.5 // 클래스 임계값
            );

        print(result); // 감지된 객체 출력
        _isDetecting = false; // 감지 완료 후 다시 감지 대기
      }
    });
  }

  Future<void> _loadYoloModel() async {
    // YOLOv8 모델과 라벨 로드
    await vision.loadYoloModel(
      labels: 'assets/labels.txt',
      modelPath: 'assets/yolov8n.tflite',
      modelVersion: "yolov8",
      quantization: false,
      numThreads: 1,
      useGpu: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    vision.closeYoloModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Nutripic - 객체 감지')),
      body: CameraPreview(_controller), // 카메라 화면 출력
    );
  }
}
