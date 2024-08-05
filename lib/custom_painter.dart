import 'package:flutter/material.dart';

class CompassPainter extends CustomPainter {
  final double direction;

  CompassPainter(this.direction);

  get math => null;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 50; // Adjusted to fit within the canvas
    final directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"];

    for (int i = 0; i < 8; i++) {
      // Adjusted angle calculation
      final angle = (i * 45.0 - direction - 90.0) * (math.pi / 180);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      canvas.drawLine(center, Offset(x, y), paint);

      // Calculate the position for the label
      final labelOffset = Offset(
        center.dx + (radius + 20) * math.cos(angle),
        center.dy + (radius + 20) * math.sin(angle),
      );

      textPainter.text = TextSpan(
        text: directions[i],
        style: const TextStyle(color: Colors.black, fontSize: 16),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        labelOffset - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
