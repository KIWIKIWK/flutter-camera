import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras(); // 카메라 목록 가져오기
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyState();
}

class _MyState extends State<MyApp> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  String? _imagePath;
  int _currentCameraIndex = 0;

  Future<void> takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _cameraController.takePicture();
      setState(() {
        _imagePath = image.path; // 촬영한 사진 경로 저장
      });
      print('사진 저장 경로: ${image.path}');
    } catch (e) {
      print('사진 촬영 중 오류 발생: $e');
    }
  }

  void initializeCamera(int cameraIndex) {
    _cameraController = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _cameraController.initialize();
  }

  void switchCamera() async {
    _currentCameraIndex =
        (_currentCameraIndex + 1) % cameras.length; // 다음 카메라 선택
    await _cameraController.dispose();
    initializeCamera(_currentCameraIndex);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializeCamera(_currentCameraIndex);
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera Example"),
        actions: [
          IconButton(
            onPressed: () {
              switchCamera();
            },
            icon: Icon(Icons.camera),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // 카메라 미리보기
                  return CameraPreview(_cameraController);
                } else {
                  // 로딩중
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: _imagePath == null
                ? Center(child: Text('촬영한 사진이 여기에 표시됩니다'))
                : Center(child: Image.file(File(_imagePath!))), // 촬영한 사진 표시
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await takePicture();
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}
