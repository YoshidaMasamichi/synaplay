import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../common/widgets/app_text_field.dart';
import '../../../../common/widgets/app_dropdown_field.dart';
import '../../../../common/widgets/section_card.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../../data/recruitment_service.dart';
import '../../domain/recruitment.dart';

class CreateRecruitmentPage extends StatefulWidget {
  const CreateRecruitmentPage({super.key});

  @override
  State<CreateRecruitmentPage> createState() => _CreateRecruitmentPageState();
}

class _CreateRecruitmentPageState extends State<CreateRecruitmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _service = RecruitmentService();

  DateTime? _selectedDate;
  String? _selectedArea;
  String? _selectedLevel;
  int _maxPlayers = 9;
  bool _isLoading = false;

  final List<String> _areas = [
    '東京都',
    '神奈川県',
    '埼玉県',
    '千葉県',
    '大阪府',
    '兵庫県',
    '愛知県',
    '福岡県',
  ];

  final List<String> _levels = ['ゆるく楽しみたい', '経験者中心でも参加したい', 'しっかりプレーしたい'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('開催日を選択してください')));
      return;
    }

    final area = _selectedArea;
    final level = _selectedLevel;
    if (area == null || level == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('エリアとレベルを選択してください')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = supabase.auth.currentUser!;
      final name = user.userMetadata?['display_name'] as String? ?? '名無し';

      await _service.create(
        Recruitment(
          id: '',
          userId: user.id,
          title: _titleController.text.trim(),
          date: _selectedDate!,
          area: area,
          level: level,
          maxPlayers: _maxPlayers,
          description: _descriptionController.text.trim(),
          createdByName: name,
          createdAt: DateTime.now(),
        ),
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } on PostgrestException catch (e) {
      if (!mounted) return;
      final message = e.message.isNotEmpty ? e.message : e.details;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('投稿に失敗しました: $message')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('投稿に失敗しました: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('募集を作成'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '一緒にやる人を募集する',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 24),
                SectionCard(
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _titleController,
                        label: 'タイトル',
                        hint: '例）土曜の草野球、参加者募集！',
                        validator: (v) =>
                            (v?.trim() ?? '').isEmpty ? 'タイトルを入力してください' : null,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _descriptionController,
                        label: '詳細',
                        hint: '集合場所・持ち物・連絡先など',
                        maxLines: 4,
                        validator: (v) =>
                            (v?.trim() ?? '').isEmpty ? '詳細を入力してください' : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    children: [
                      // 開催日
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 18,
                                color: AppColors.textSub,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                _selectedDate == null
                                    ? '開催日を選択'
                                    : '${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}',
                                style: TextStyle(
                                  color: _selectedDate == null
                                      ? AppColors.textSub
                                      : AppColors.textMain,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: 'エリア',
                        value: _selectedArea,
                        items: _areas,
                        onChanged: (v) => setState(() => _selectedArea = v),
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: 'レベル感',
                        value: _selectedLevel,
                        items: _levels,
                        onChanged: (v) => setState(() => _selectedLevel = v),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Text(
                            '定員',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMain,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: _maxPlayers > 1
                                ? () => setState(() => _maxPlayers--)
                                : null,
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            '$_maxPlayers 人',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            onPressed: _maxPlayers < 30
                                ? () => setState(() => _maxPlayers++)
                                : null,
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
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
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            '募集を投稿する',
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
      ),
    );
  }
}
