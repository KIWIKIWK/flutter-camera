import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mlkit_sandbox/watch_painter.dart';

class PaintWidget extends StatefulWidget {
  const PaintWidget({super.key});

  @override
  State<PaintWidget> createState() => _PaintWidgetState();
}

class _PaintWidgetState extends State<PaintWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late DateTime now;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )
      ..repeat(reverse: true);
    now = DateTime.now().add(Duration(hours: 9));

    Timer.periodic(Duration(seconds: 1),(timer){
      setState(() {
        now = DateTime.now().add(Duration(hours: 9));
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Paint Example"),
        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width / 2,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.white
              )
            ),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: CustomPaint(
                painter: WatchPainter(now),

              ),
            ),
          ),
        )
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    canvas.drawCircle(center, radius, paint); // 원 그리기
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // 다시 그리기 필요 없음
  }
}

class AnimatedCirclePainter extends CustomPainter {
  final double radius;

  AnimatedCirclePainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // 애니메이션 상태 변경에 따라 다시 그리기
  }
}