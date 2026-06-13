import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../common/widgets/section_card.dart';
import '../../../../common/widgets/summary_line.dart';
import '../../domain/player_card_draft.dart';
import '../../domain/signup_draft.dart';
import 'landing_page.dart';

class RegistrationCompletePage extends StatelessWidget {
  final SignupDraft signupDraft;
  final PlayerCardDraft playerCardDraft;

  const RegistrationCompletePage({
    super.key,
    required this.signupDraft,
    required this.playerCardDraft,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登録完了'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 38,
                  color: AppColors.primaryDeep,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '${signupDraft.displayName} さん、登録が完了しました。',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '次はホームや募集一覧につながる本体画面を実装していきます。現段階では登録導線の骨格まで通っています。',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSub,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '保存予定データ（UI上の確認）',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SummaryLine(label: '表示名', value: signupDraft.displayName),
                    SummaryLine(label: 'メールアドレス', value: signupDraft.email),
                    SummaryLine(label: '活動エリア', value: playerCardDraft.activityArea),
                    SummaryLine(
                      label: '守れるポジション',
                      value: playerCardDraft.playablePositions.join(' / '),
                    ),
                    SummaryLine(
                      label: '参加スタイル',
                      value: playerCardDraft.participationStyle,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LandingPage()),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'トップへ戻る',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}