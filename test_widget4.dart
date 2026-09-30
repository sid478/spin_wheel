// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:company_spin_wheel/company_spin_wheel.dart';

void main() {
  testWidgets('Test Default', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SpinWheel(
          items: [SpinItem(label: '1', id: 1), SpinItem(label: '2', id: 2)],
        ),
      ),
    ));
    expect(find.byType(SpinWheel<dynamic>), findsOneWidget);
  });
  
  testWidgets('Test Single Color', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SpinWheel(
          items: [SpinItem(label: '1', id: 1), SpinItem(label: '2', id: 2)],
          theme: SpinWheelTheme(outerRingColor: Colors.red),
        ),
      ),
    ));
    expect(find.byType(SpinWheel<dynamic>), findsOneWidget);
  });
}
