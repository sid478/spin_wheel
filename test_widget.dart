import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'lib/src/widgets/spin_wheel.dart';
import 'lib/src/models/spin_item.dart';
import 'lib/src/theme/spin_wheel_theme.dart';

void main() {
  testWidgets('Test SpinWheel', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SpinWheel(
          items: [
            SpinItem(label: '1', id: 1),
            SpinItem(label: '2', id: 2),
          ],
          theme: SpinWheelTheme(
            outerRingGradient: const SweepGradient(
              colors: [
                Color(0xFF4FC3F7),
                Color(0xFF01579B),
              ],
            ),
          ),
        ),
      ),
    ));
    
    expect(find.byType(SpinWheel), findsOneWidget);
    print('Widget rendered successfully');
  });
}
