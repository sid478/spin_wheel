// ignore_for_file: unused_import, avoid_relative_lib_imports, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:company_spin_wheel/company_spin_wheel.dart';
import 'example/lib/main.dart';

void main() {
  testWidgets('Test Example App', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());
    expect(find.byType(SpinWheel<String>), findsOneWidget);
    print('Widget rendered successfully');
  });
}
