class PlayerCardDraft {
  final String activityArea;
  final String ageRange;
  final String handedness;
  final String experienceYears;
  final List<String> playablePositions;
  final String desiredPosition;
  final String pitcherAvailability;
  final String catcherAvailability;
  final String level;
  final String blankStatus;
  final String gloveStatus;
  final String batStatus;
  final String spikeStatus;
  final String participationStyle;

  const PlayerCardDraft({
    required this.activityArea,
    required this.ageRange,
    required this.handedness,
    required this.experienceYears,
    required this.playablePositions,
    required this.desiredPosition,
    required this.pitcherAvailability,
    required this.catcherAvailability,
    required this.level,
    required this.blankStatus,
    required this.gloveStatus,
    required this.batStatus,
    required this.spikeStatus,
    required this.participationStyle,
  });
}