import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/supabase/supabase_client.dart';
import 'features/auth/presentation/pages/landing_page.dart';
import 'features/home/presentation/pages/home_page.dart';

class SynaPlayApp extends StatelessWidget {
  const SynaPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = supabase.auth.currentUser != null;

    return MaterialApp(
      title: 'SynaPlay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: isLoggedIn ? const HomePage() : const LandingPage(),
    );
  }
}
