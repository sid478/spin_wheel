import 'dart:math' as math;
import 'package:flutter/material.dart';

enum SpinMarkerType {
  triangle,
  pin,
}

class SpinWheelMarker extends StatelessWidget {
  const SpinWheelMarker({
    super.key,
    this.type = SpinMarkerType.triangle,
    this.color = const Color(0xFFFFC107),
    this.borderColor = const Color(0xFF8A5A00),
    this.size = 62,
    this.image,
  });

  final SpinMarkerType type;
  final Color color;
  final Color borderColor;
  final double size;
  final Widget? image;

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return SizedBox(
        width: size,
        height: size,
        child: image,
      );
    }

    return CustomPaint(
      size: Size(size, size),
      painter: _MarkerPainter(
        type: type,
        color: color,
        borderColor: borderColor,
      ),
    );
  }
}

class _MarkerPainter extends CustomPainter {
  const _MarkerPainter({
    required this.type,
    required this.color,
    required this.borderColor,
  });

  final SpinMarkerType type;
  final Color color;
  final Color borderColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;

    switch (type) {
      case SpinMarkerType.triangle:
        _drawCustomDefaultMarker(canvas, size);
        return;
      case SpinMarkerType.pin:
        path
          ..moveTo(w / 2, h)
          ..cubicTo(0, h * .25, 0, 0, w / 2, 0)
          ..cubicTo(w, 0, w, h * .25, w / 2, h)
          ..close();
        path.close();
    }

    final fill = Paint()..color = color;
    final stroke = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, fill);
    canvas.drawPath(path, stroke);
  }

  void _drawCustomDefaultMarker(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final topWidth = w * 0.70;
    final topY = h * 0.30;

    final leftTrianglePath = Path()
      ..moveTo(w / 2, h)
      ..lineTo(w / 2 - topWidth / 2, topY)
      ..lineTo(w / 2, topY)
      ..close();

    final rightTrianglePath = Path()
      ..moveTo(w / 2, h)
      ..lineTo(w / 2, topY)
      ..lineTo(w / 2 + topWidth / 2, topY)
      ..close();

    final triangleShadowPath = Path()
      ..moveTo(w / 2, h)
      ..lineTo(w / 2 - topWidth / 2, topY)
      ..lineTo(w / 2 + topWidth / 2, topY)
      ..close();
    canvas.drawShadow(triangleShadowPath, Colors.black, 4, false);

    canvas.drawPath(leftTrianglePath, Paint()..color = const Color(0xFFE93C20));
    canvas.drawPath(rightTrianglePath, Paint()..color = const Color(0xFFBC1B06));

    final starCenter = Offset(w / 2, topY - h * 0.04);
    final outerR = w * 0.34;
    final innerR = w * 0.14;

    final points = <Offset>[];
    for (var i = 0; i < 10; i++) {
      final r = i.isEven ? outerR : innerR;
      final angle = -3.141592653589793 / 2 + i * 3.141592653589793 / 5;
      points.add(Offset(
        starCenter.dx + r * math.cos(angle),
        starCenter.dy + r * math.sin(angle),
      ));
    }

    final starPath = Path();
    starPath.moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < 10; i++) {
      starPath.lineTo(points[i].dx, points[i].dy);
    }
    starPath.close();
    canvas.drawShadow(starPath, Colors.black, 3, false);

    final brightYellow = const Color(0xFFFFD54F);
    final darkYellow = const Color(0xFFF57F17);

    for (var i = 0; i < 10; i += 2) {
      final prevInner = points[(i - 1 + 10) % 10];
      final outer = points[i];
      final nextInner = points[(i + 1) % 10];

      final leftFacet = Path()
        ..moveTo(starCenter.dx, starCenter.dy)
        ..lineTo(prevInner.dx, prevInner.dy)
        ..lineTo(outer.dx, outer.dy)
        ..close();
      canvas.drawPath(leftFacet, Paint()..color = brightYellow);

      final rightFacet = Path()
        ..moveTo(starCenter.dx, starCenter.dy)
        ..lineTo(outer.dx, outer.dy)
        ..lineTo(nextInner.dx, nextInner.dy)
        ..close();
      canvas.drawPath(rightFacet, Paint()..color = darkYellow);
    }
  }

  @override
  bool shouldRepaint(covariant _MarkerPainter oldDelegate) {
    return oldDelegate.type != type ||
        oldDelegate.color != color ||
        oldDelegate.borderColor != borderColor;
  }
}
