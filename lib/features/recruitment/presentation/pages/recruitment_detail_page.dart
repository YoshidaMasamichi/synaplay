import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../../../../common/widgets/section_card.dart';
import '../../data/participation_service.dart';
import '../../domain/recruitment.dart';

class RecruitmentDetailPage extends StatefulWidget {
  final Recruitment recruitment;

  const RecruitmentDetailPage({super.key, required this.recruitment});

  @override
  State<RecruitmentDetailPage> createState() => _RecruitmentDetailPageState();
}

class _RecruitmentDetailPageState extends State<RecruitmentDetailPage> {
  final _service = ParticipationService();
  bool _isJoined = false;
  List<Map<String, dynamic>> _participants = [];
  bool _isLoading = true;
  bool _isActionLoading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final joined = await _service.isJoined(widget.recruitment.id);
      final participants =
          await _service.fetchParticipants(widget.recruitment.id);
      if (mounted) {
        setState(() {
          _isJoined = joined;
          _participants = participants;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleJoin() async {
    setState(() => _isActionLoading = true);
    try {
      if (_isJoined) {
        await _service.cancel(widget.recruitment.id);
      } else {
        final name = supabase.auth.currentUser
                ?.userMetadata?['display_name'] as String? ??
            '名無し';
        await _service.join(widget.recruitment.id, name);
      }
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('操作に失敗しました: $e')),
      );
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  String _formatDate(DateTime date) {
    const weekdays = ['月', '火', '水', '木', '金', '土', '日'];
    return '${date.year}年${date.month}月${date.day}日（${weekdays[date.weekday - 1]}）';
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.recruitment;
    final isMine =
        supabase.auth.currentUser?.id == r.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('募集詳細'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _Chip(r.area, color: AppColors.primary.withValues(alpha: 0.12), textColor: AppColors.primaryDeep),
                        const SizedBox(width: 8),
                        _Chip(r.level, color: Colors.grey.shade100, textColor: AppColors.textSub),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      r.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SectionCard(
                      child: Column(
                        children: [
                          _InfoRow(Icons.calendar_today_outlined, '開催日', _formatDate(r.date)),
                          const Divider(height: 24),
                          _InfoRow(Icons.people_outline, '定員', '${r.maxPlayers} 人'),
                          const Divider(height: 24),
                          _InfoRow(Icons.person_outline, '主催者', r.createdByName),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('詳細',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textMain)),
                          const SizedBox(height: 10),
                          Text(r.description,
                              style: const TextStyle(
                                  color: AppColors.textSub, height: 1.6)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('参加者',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textMain)),
                              const SizedBox(width: 8),
                              Text(
                                '${_participants.length} / ${r.maxPlayers} 人',
                                style: const TextStyle(
                                    color: AppColors.textSub, fontSize: 13),
                              ),
                            ],
                          ),
                          if (_participants.isEmpty) ...[
                            const SizedBox(height: 12),
                            const Text('まだ参加者がいません',
                                style: TextStyle(
                                    color: AppColors.textSub, fontSize: 13)),
                          ] else ...[
                            const SizedBox(height: 12),
                            ..._participants.map((p) => Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.sports_baseball,
                                          size: 16,
                                          color: AppColors.primary),
                                      const SizedBox(width: 8),
                                      Text(
                                        p['display_name'] as String? ?? '名無し',
                                        style: const TextStyle(
                                            color: AppColors.textMain),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: isMine
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: SizedBox(
                  height: 54,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          _isJoined ? Colors.grey.shade400 : AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: (_isActionLoading ||
                            (!_isJoined &&
                                _participants.length >= r.maxPlayers))
                        ? null
                        : _toggleJoin,
                    child: _isActionLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(
                            _isJoined
                                ? '参加を取り消す'
                                : _participants.length >= r.maxPlayers
                                    ? '定員に達しました'
                                    : '参加する',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  const _Chip(this.label, {required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(label,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSub),
        const SizedBox(width: 10),
        Text(label,
            style: const TextStyle(color: AppColors.textSub, fontSize: 14)),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                color: AppColors.textMain,
                fontWeight: FontWeight.w600,
                fontSize: 14)),
      ],
    );
  }
}
