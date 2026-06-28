import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../../../auth/data/auth_service.dart';
import '../../../auth/presentation/pages/landing_page.dart';
import '../../data/recruitment_service.dart';
import '../../domain/recruitment.dart';
import 'create_recruitment_page.dart';
import 'recruitment_detail_page.dart';

class RecruitmentListPage extends StatefulWidget {
  const RecruitmentListPage({super.key});

  @override
  State<RecruitmentListPage> createState() => _RecruitmentListPageState();
}

class _RecruitmentListPageState extends State<RecruitmentListPage> {
  final _service = RecruitmentService();
  late Future<List<Recruitment>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchAll();
  }

  void _reload() {
    setState(() => _future = _service.fetchAll());
  }

  String _formatDate(DateTime date) =>
      '${date.month}/${date.day}（${['月', '火', '水', '木', '金', '土', '日'][date.weekday - 1]}）';

  @override
  Widget build(BuildContext context) {
    final displayName =
        supabase.auth.currentUser?.userMetadata?['display_name'] as String? ??
        'プレイヤー';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SynaPlay',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDeep,
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService().signOut();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LandingPage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'ログアウト',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Text(
                'こんにちは、$displayName さん',
                style: const TextStyle(fontSize: 16, color: AppColors.textSub),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Recruitment>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            '読み込みに失敗しました',
                            style: TextStyle(color: AppColors.textSub),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _reload,
                            child: const Text('再試行'),
                          ),
                        ],
                      ),
                    );
                  }

                  final list = snapshot.data ?? [];
                  if (list.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.sports_baseball,
                            size: 48,
                            color: AppColors.border,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'まだ募集がありません',
                            style: TextStyle(
                              color: AppColors.textSub,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '右下のボタンから最初の募集を作ってみましょう',
                            style: TextStyle(
                              color: AppColors.textSub,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _reload(),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final r = list[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  RecruitmentDetailPage(recruitment: r),
                            ),
                          ),
                          child: _RecruitmentCard(
                            recruitment: r,
                            formatDate: _formatDate,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const CreateRecruitmentPage()),
          );
          if (created == true) _reload();
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text(
          '募集を作る',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _RecruitmentCard extends StatelessWidget {
  final Recruitment recruitment;
  final String Function(DateTime) formatDate;

  const _RecruitmentCard({required this.recruitment, required this.formatDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  recruitment.area,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDeep,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  recruitment.level,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSub,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            recruitment.title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            recruitment.description,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSub,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: AppColors.textSub,
              ),
              const SizedBox(width: 4),
              Text(
                formatDate(recruitment.date),
                style: const TextStyle(fontSize: 13, color: AppColors.textSub),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.people_outline,
                size: 14,
                color: AppColors.textSub,
              ),
              const SizedBox(width: 4),
              Text(
                '定員 ${recruitment.maxPlayers} 人',
                style: const TextStyle(fontSize: 13, color: AppColors.textSub),
              ),
              const Spacer(),
              Text(
                recruitment.createdByName,
                style: const TextStyle(fontSize: 12, color: AppColors.textSub),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
