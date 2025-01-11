import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  State<CameraWidget> createState() => _MyState();
}

class _MyState extends State<CameraWidget> {
  List<CameraDescription> _cameras = [];
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  int _currentCameraIndex = 0;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // 카메라 초기화 메서드
  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras(); // 사용 가능한 카메라 목록 가져오기
      _cameraController = CameraController(
        _cameras[0], // 첫 번째 카메라 (후면)
        ResolutionPreset.high, // 해상도 설정
      );
      _initializeControllerFuture = _cameraController.initialize();
      setState(() {}); // 상태 갱신
    } catch (e) {
      print('카메라 초기화 중 오류 발생: $e');
    }
  }

  @override
  void dispose() {
    _cameraController.dispose(); // 리소스 해제
    super.dispose();
  }

  void switchCamera() async {
    _currentCameraIndex =
        (_currentCameraIndex + 1) % _cameras.length; // 다음 카메라 선택
    await _cameraController.dispose();
    _cameraController = CameraController(
      _cameras[_currentCameraIndex],
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _cameraController.initialize();
    setState(() {});
  }

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

  @override
  Widget build(BuildContext context) {
    if (_cameras.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Camera Example')),
        body: Center(
          child: Text('카메라를 사용할 수 없습니다.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Example'),
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
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CameraPreview(_cameraController); // 카메라 미리보기 표시
                } else {
                  return Center(child: CircularProgressIndicator()); // 로딩 중 표시
                }
              },
            ),
          ),
          Expanded(
            child: _imagePath == null
                ? Center(
                    child: Text("저장된 사진이 없습니다."),
                  )
                : Center(
                    child: Image.file(
                      File(_imagePath!),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          takePicture();
        },
        child: Icon(Icons.camera),
      ),
    );
  }
}
