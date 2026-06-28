import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../common/widgets/app_dropdown_field.dart';
import '../../../../common/widgets/section_card.dart';
import '../../domain/player_card_draft.dart';
import '../../domain/signup_draft.dart';
import 'registration_complete_page.dart';

class PlayerCardSetupPage extends StatefulWidget {
  final SignupDraft signupDraft;

  const PlayerCardSetupPage({super.key, required this.signupDraft});

  @override
  State<PlayerCardSetupPage> createState() => _PlayerCardSetupPageState();
}

class _PlayerCardSetupPageState extends State<PlayerCardSetupPage> {
  final _formKey = GlobalKey<FormState>();

  final List<String> _activityAreas = [
    '東京都',
    '神奈川県',
    '埼玉県',
    '千葉県',
    '大阪府',
    '兵庫県',
    '愛知県',
    '福岡県',
  ];

  final List<String> _ageRanges = [
    '10代',
    '20代前半',
    '20代後半',
    '30代前半',
    '30代後半',
    '40代',
    '50代以上',
  ];

  final List<String> _handednessOptions = [
    '右投げ右打ち',
    '右投げ左打ち',
    '左投げ左打ち',
    '左投げ右打ち',
    'その他',
  ];

  final List<String> _experienceOptions = [
    '未経験',
    '1〜3年',
    '4〜6年',
    '7〜10年',
    '11年以上',
  ];

  final List<String> _positions = ['投手', '捕手', '一塁', '二塁', '三塁', '遊撃', '外野'];

  final List<String> _levelOptions = ['ゆるく楽しみたい', '経験者中心でも参加したい', 'しっかりプレーしたい'];

  final List<String> _binaryOptions = ['はい', 'いいえ'];

  final List<String> _participationStyles = [
    '予定が合う時に参加したい',
    '月1〜2回くらい参加したい',
    '継続的に参加したい',
  ];

  String? _selectedActivityArea;
  String? _selectedAgeRange;
  String? _selectedHandedness;
  String? _selectedExperience;
  String? _selectedDesiredPosition;
  String? _selectedPitcherAvailability;
  String? _selectedCatcherAvailability;
  String? _selectedLevel;
  String? _selectedBlankStatus;
  String? _selectedGloveStatus;
  String? _selectedBatStatus;
  String? _selectedSpikeStatus;
  String? _selectedParticipationStyle;

  final Set<String> _selectedPlayablePositions = {};

  void _togglePlayablePosition(String position) {
    setState(() {
      if (_selectedPlayablePositions.contains(position)) {
        _selectedPlayablePositions.remove(position);
      } else {
        _selectedPlayablePositions.add(position);
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPlayablePositions.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('守れるポジションを1つ以上選択してください')));
      return;
    }

    final playerCard = PlayerCardDraft(
      activityArea: _selectedActivityArea!,
      ageRange: _selectedAgeRange!,
      handedness: _selectedHandedness!,
      experienceYears: _selectedExperience!,
      playablePositions: _selectedPlayablePositions.toList(),
      desiredPosition: _selectedDesiredPosition!,
      pitcherAvailability: _selectedPitcherAvailability!,
      catcherAvailability: _selectedCatcherAvailability!,
      level: _selectedLevel!,
      blankStatus: _selectedBlankStatus!,
      gloveStatus: _selectedGloveStatus!,
      batStatus: _selectedBatStatus!,
      spikeStatus: _selectedSpikeStatus!,
      participationStyle: _selectedParticipationStyle!,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RegistrationCompletePage(
          signupDraft: widget.signupDraft,
          playerCardDraft: playerCard,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.signupDraft.displayName;

    return Scaffold(
      appBar: AppBar(
        title: const Text('プレイヤーカード設定'),
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
                  'プレイヤーカードを設定します',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '$name さんに合う募集を見つけやすくするために、プレイヤーカードを設定します。',
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSub,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                SectionCard(
                  child: Column(
                    children: [
                      AppDropdownField<String>(
                        label: '活動エリア',
                        value: _selectedActivityArea,
                        items: _activityAreas,
                        onChanged: (value) =>
                            setState(() => _selectedActivityArea = value),
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: '年齢帯',
                        value: _selectedAgeRange,
                        items: _ageRanges,
                        onChanged: (value) =>
                            setState(() => _selectedAgeRange = value),
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: '利き手',
                        value: _selectedHandedness,
                        items: _handednessOptions,
                        onChanged: (value) =>
                            setState(() => _selectedHandedness = value),
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: '経験年数',
                        value: _selectedExperience,
                        items: _experienceOptions,
                        onChanged: (value) =>
                            setState(() => _selectedExperience = value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '守れるポジション',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _positions.map((position) {
                          final selected = _selectedPlayablePositions.contains(
                            position,
                          );
                          return FilterChip(
                            label: Text(position),
                            selected: selected,
                            onSelected: (_) =>
                                _togglePlayablePosition(position),
                            selectedColor: AppColors.primary.withValues(
                              alpha: 0.18,
                            ),
                            checkmarkColor: AppColors.primaryDeep,
                            side: const BorderSide(color: AppColors.border),
                            labelStyle: TextStyle(
                              color: selected
                                  ? AppColors.primaryDeep
                                  : AppColors.textMain,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: '希望ポジション',
                        value: _selectedDesiredPosition,
                        items: _positions,
                        onChanged: (value) =>
                            setState(() => _selectedDesiredPosition = value),
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: '投手できますか',
                        value: _selectedPitcherAvailability,
                        items: _binaryOptions,
                        onChanged: (value) => setState(
                          () => _selectedPitcherAvailability = value,
                        ),
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: '捕手できますか',
                        value: _selectedCatcherAvailability,
                        items: _binaryOptions,
                        onChanged: (value) => setState(
                          () => _selectedCatcherAvailability = value,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                SectionCard(
                  child: Column(
                    children: [
                      AppDropdownField<String>(
                        label: 'レベル感',
                        value: _selectedLevel,
                        items: _levelOptions,
                        onChanged: (value) =>
                            setState(() => _selectedLevel = value),
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: 'ブランクはありますか',
                        value: _selectedBlankStatus,
                        items: _binaryOptions,
                        onChanged: (value) =>
                            setState(() => _selectedBlankStatus = value),
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: 'グローブはありますか',
                        value: _selectedGloveStatus,
                        items: _binaryOptions,
                        onChanged: (value) =>
                            setState(() => _selectedGloveStatus = value),
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: 'バットはありますか',
                        value: _selectedBatStatus,
                        items: _binaryOptions,
                        onChanged: (value) =>
                            setState(() => _selectedBatStatus = value),
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: 'スパイクはありますか',
                        value: _selectedSpikeStatus,
                        items: _binaryOptions,
                        onChanged: (value) =>
                            setState(() => _selectedSpikeStatus = value),
                      ),
                      const SizedBox(height: 16),
                      AppDropdownField<String>(
                        label: '参加スタイル',
                        value: _selectedParticipationStyle,
                        items: _participationStyles,
                        onChanged: (value) =>
                            setState(() => _selectedParticipationStyle = value),
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
                    onPressed: _submit,
                    child: const Text(
                      '保存してはじめる',
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
