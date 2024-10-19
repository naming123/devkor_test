import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'dart:io'; // For saving the image
import 'dart:typed_data'; // Uint8List 관련 라이브러리
import 'package:path_provider/path_provider.dart'; // For getting app directory

// List<Uint8List>를 하나의 Uint8List로 병합하는 함수
Uint8List concatenateBytes(List<Uint8List> byteList) {
  int totalLength = byteList.fold(0, (length, bytes) => length + bytes.length);
  Uint8List result = Uint8List(totalLength);
  int offset = 0;

  for (var bytes in byteList) {
    result.setRange(offset, offset + bytes.length, bytes);
    offset += bytes.length;
  }

  return result;
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isDetecting = false;
  FlutterVision vision = FlutterVision();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadYoloModel();
  }

  Future<void> _initializeCamera() async {
    // Get available cameras and initialize the first one
    final cameras = await availableCameras();
    _controller = CameraController(cameras[0], ResolutionPreset.high);

    _initializeControllerFuture = _controller.initialize();
  }

  Future<void> _loadYoloModel() async {
    // Load YOLOv8 model
    await vision.loadYoloModel(
      labels: 'assets/labels.txt',
      modelPath: 'assets/yolov8n.tflite',
      modelVersion: "yolov8",
      quantization: false,
      numThreads: 1,
      useGpu: false,
    );
  }

  Future<void> _captureAndDetect() async {
    try {
      // Ensure the camera is initialized
      await _initializeControllerFuture;

      // Capture the image
      final image = await _controller.takePicture();

      // Optionally save the image to the device (storage permission may be needed)
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      File(image.path).copy(imagePath); // Save the image

      // Process the image with YOLOv8
      if (!_isDetecting) {
        _isDetecting = true;

        // Load image bytes for YOLOv8 detection
        final bytes = await File(imagePath).readAsBytes();

        // List<Uint8List>를 병합하여 Uint8List로 변환
        Uint8List concatenatedBytes = concatenateBytes([bytes]);

        final result = await vision.yoloOnImage(
          bytesList: concatenatedBytes, // Uint8List 전달
          imageHeight: _controller.value.previewSize?.height.toInt() ?? 0,
          imageWidth: _controller.value.previewSize?.width.toInt() ?? 0,
          iouThreshold: 0.4,
          confThreshold: 0.4,
          classThreshold: 0.5,
        );

        print('Detection result: $result');
        _isDetecting = false;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    vision.closeYoloModel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Screen'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller), // Camera feed preview
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: _captureAndDetect,
                    child: const Icon(Icons.camera),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
