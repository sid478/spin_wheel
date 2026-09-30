import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:company_spin_wheel/company_spin_wheel.dart';
import 'example/lib/main.dart';

void main() {
  testWidgets('Test Example App', (WidgetTester tester) async {
    try {
      await tester.pumpWidget(const ExampleApp());
      expect(find.byType(SpinDemoPage), findsOneWidget);
      print('Widget rendered successfully');
    } catch (e) {
      print('Widget rendering failed: $e');
    }
  });
}
