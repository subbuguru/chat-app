
import 'package:flutter/material.dart';

class MessageBubble extends CustomPainter {
  final bool isCurrentUser;

  MessageBubble({required this.isCurrentUser});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isCurrentUser ? Colors.blue.shade900 : Colors.grey.shade800;

    var path = Path();

    if (isCurrentUser) {
      path.moveTo(size.width - 20, size.height);
      path.quadraticBezierTo(
        size.width, size.height,
        size.width, size.height - 20,
      );
      path.lineTo(size.width, 20);
      path.quadraticBezierTo(
        size.width, 0,
        size.width - 20, 0,
      );
      path.lineTo(20, 0);
      path.quadraticBezierTo(
        0, 0,
        0, 20,
      );
      path.lineTo(0, size.height - 20);
      path.quadraticBezierTo(
        0, size.height,
        20, size.height,
      );
      path.close();
    } else {
      path.moveTo(20, size.height);
      path.quadraticBezierTo(
        0, size.height,
        0, size.height - 20,
      );
      path.lineTo(0, 20);
      path.quadraticBezierTo(
        0, 0,
        20, 0,
      );
      path.lineTo(size.width - 20, 0);
      path.quadraticBezierTo(
        size.width, 0,
        size.width, 20,
      );
      path.lineTo(size.width, size.height - 20);
      path.quadraticBezierTo(
        size.width, size.height,
        size.width - 20, size.height,
      );
      path.close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

