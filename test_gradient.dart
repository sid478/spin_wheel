import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test SweepGradient', (WidgetTester tester) async {
    final gradient = const SweepGradient(
      colors: [
        Color(0xFF4FC3F7),
        Color(0xFF01579B),
      ],
    );
    try {
      final shader = gradient.createShader(
        Rect.fromCircle(center: Offset(100, 100), radius: 100),
      );
      print('Shader created successfully: $shader');
    } catch (e, stack) {
      print('Error: $e\n$stack');
    }
  });
}
