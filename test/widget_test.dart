import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:synaplay/app.dart';
import 'package:synaplay/core/config/supabase_config.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});

    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  });

  testWidgets('SynaPlayApp renders without errors', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SynaPlayApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
