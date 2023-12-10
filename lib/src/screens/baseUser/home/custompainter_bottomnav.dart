import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.white; 

    double circleRadius = size.width / 2 + 10;
    double circleCenter = size.height - circleRadius -20;
    canvas.drawCircle(
      Offset(size.width / 2, circleCenter),
      circleRadius,
      paint,
    );
    Path path = Path();
    path.moveTo(size.width / 2 - 20, circleCenter); 
    path.lineTo(size.width / 2 + 20, circleCenter); 
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}