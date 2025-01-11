import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class WatchPainter extends CustomPainter {
  final TextPainter tp;
  final Color primaryColor;
  final DateTime now;

  WatchPainter(this.now,)
      : tp = TextPainter(
          textDirection: TextDirection.ltr,
        ),
        primaryColor = Color(0xFFE57242);

  @override
  void paint(Canvas canvas, Size size) {
    final xCenter = size.width / 2;
    final yCenter = size.height / 2;

    final angle = (2 * pi) / 12;

    debugPrint("${xCenter} , ${yCenter}, ${angle} // xCenter, yCenter, angle");

    canvas.save();

    canvas.translate(xCenter, yCenter);
    // 센터를 잡고 시작

    renderText(canvas, size, xCenter, yCenter, angle);
    renderHands(canvas, size, xCenter, yCenter);
    canvas.restore();

    // tp.text = TextSpan( // tp에 텍스트 설정
    //   text: "test",
    //   style: TextStyle(
    //     color: Colors.white,
    //     fontSize: 20,
    //   )
    // );
    //
    // tp.layout(); // 텍스트를 그리기 위한 문자모양의 시각적 위치 계산, paint하기전에 먼저 써야하는듯?
    // tp.paint(canvas, Offset(xCenter,yCenter));
  }

  renderHands(Canvas canvas, Size size, double xCenter, double yCenter) {
    canvas.save();

    final innerPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final outerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final secPaint = Paint()
      ..color = primaryColor
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.square;

    final rootPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.square;

    final rootWhiteCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final rootPrimaryCirclePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final rootBlackCirclePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final rootOffset = 14.0;

    DateTime now = DateTime.now().add(Duration(hours: 9));

    final hourAngle =
        (now.hour % 12) * (2 * pi / 12) + (now.minute) * (2 * pi / (12 * 60));

    final minuteAngle = now.minute * (2*pi/60);
    final secAngle = now.second * (2*pi/60);

    // 시침
    canvas.save();

    canvas.rotate(hourAngle);
    canvas.drawLine(Offset.zero, Offset(0, -rootOffset), rootPaint);
    canvas.drawLine(
        Offset(0, -rootOffset), Offset(0, -xCenter * 0.7), outerPaint);
    canvas.drawLine(
        Offset(0, -rootOffset), Offset(0, -xCenter * 0.7), innerPaint);
    canvas.restore();
    // 분침
    canvas.save();
    canvas.rotate(minuteAngle);
    canvas.drawLine(Offset.zero, Offset(0, -rootOffset), rootPaint);
    canvas.drawLine(
        Offset(0, -rootOffset), Offset(0, -xCenter * 0.9), outerPaint);
    canvas.drawLine(
        Offset(0, -rootOffset), Offset(0, -xCenter * 0.9), innerPaint);
    canvas.restore();

    //초침
    canvas.save();

    canvas.rotate(secAngle);
    canvas.drawLine(Offset(0, 10), Offset(0, -xCenter * 0.9), secPaint);
    canvas.drawCircle(Offset.zero, 6.0, rootWhiteCirclePaint);
    canvas.drawCircle(Offset.zero, 4.0, rootPrimaryCirclePaint);
    canvas.drawCircle(Offset.zero, 2.0, rootBlackCirclePaint);

    canvas.restore();

    canvas.restore();
  }

  renderText(
      Canvas canvas, Size size, double xCenter, double yCenter, double angle) {
    canvas.save();

    final vertLength = yCenter / cos(angle);
    final horiLength = xCenter / sin(angle * 2);

    debugPrint("${vertLength} / ${horiLength} // vertlength horilength");
    final lengthList = [
      yCenter,
      vertLength,
      horiLength,
      xCenter,
      horiLength,
      vertLength,
      yCenter,
    ];

    for (int i = 0; i < 12; i++) {
      canvas.save();

      canvas.translate(0.0, -lengthList[i % 6]);

      debugPrint("${lengthList[i%6]} // lengthList");

      final display = i == 0 ? '12' : i.toString();

      tp.text = TextSpan(
        text: display,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      );

      canvas.rotate(-angle * i);
      tp.layout();
      tp.paint(
        canvas,
        Offset(-(tp.width) / 2, -(tp.height / 2)),
      );

      canvas.restore();

      canvas.rotate(angle);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
