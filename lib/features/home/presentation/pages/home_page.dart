import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../../../auth/data/auth_service.dart';
import '../../../auth/presentation/pages/landing_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final displayName =
        user?.userMetadata?['display_name'] as String? ?? 'プレイヤー';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SynaPlay',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDeep,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await AuthService().signOut();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LandingPage()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout_outlined),
                    tooltip: 'ログアウト',
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.sports_baseball,
                  size: 36,
                  color: AppColors.primaryDeep,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'おかえり、$displayName さん',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '募集一覧やイベントはこれから実装していきます。\n引き続き一緒に作っていきましょう。',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSub,
                  height: 1.6,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
