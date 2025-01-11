import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras = [];

void main() async{
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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
