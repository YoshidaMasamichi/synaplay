import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../common/widgets/section_card.dart';
import '../../../../common/widgets/summary_line.dart';
import '../../data/auth_service.dart';
import '../../domain/player_card_draft.dart';
import '../../domain/signup_draft.dart';
import '../../../home/presentation/pages/home_page.dart';

class RegistrationCompletePage extends StatefulWidget {
  final SignupDraft signupDraft;
  final PlayerCardDraft playerCardDraft;

  const RegistrationCompletePage({
    super.key,
    required this.signupDraft,
    required this.playerCardDraft,
  });

  @override
  State<RegistrationCompletePage> createState() =>
      _RegistrationCompletePageState();
}

class _RegistrationCompletePageState extends State<RegistrationCompletePage> {
  bool _isSaving = false;

  Future<void> _goHome() async {
    setState(() => _isSaving = true);
    try {
      await AuthService().savePlayerCard(widget.playerCardDraft);
    } catch (_) {
      // DB 保存失敗でもホームには進める
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

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
                  color: AppColors.accent.withValues(alpha: 0.18),
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
                '${widget.signupDraft.displayName} さん、登録が完了しました。',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMain,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'プレイヤーカードを保存してホームへ進みます。',
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
                      '登録内容',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SummaryLine(
                      label: '表示名',
                      value: widget.signupDraft.displayName,
                    ),
                    SummaryLine(
                      label: 'メールアドレス',
                      value: widget.signupDraft.email,
                    ),
                    SummaryLine(
                      label: '活動エリア',
                      value: widget.playerCardDraft.activityArea,
                    ),
                    SummaryLine(
                      label: '守れるポジション',
                      value: widget.playerCardDraft.playablePositions.join(
                        ' / ',
                      ),
                    ),
                    SummaryLine(
                      label: '参加スタイル',
                      value: widget.playerCardDraft.participationStyle,
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
                  onPressed: _isSaving ? null : _goHome,
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'ホームへ進む',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
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
