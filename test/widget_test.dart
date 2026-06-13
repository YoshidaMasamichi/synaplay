import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:synaplay/app.dart';

void main() {
  testWidgets('SynaPlayApp renders without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const SynaPlayApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
