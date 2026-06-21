import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/supabase/supabase_client.dart';
import '../domain/player_card_draft.dart';

class AuthService {
  User? get currentUser => supabase.auth.currentUser;

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<void> savePlayerCard(PlayerCardDraft card) async {
    final userId = currentUser?.id;
    if (userId == null) throw Exception('ログインが必要です');

    await supabase.from('player_cards').upsert({
      'user_id': userId,
      'activity_area': card.activityArea,
      'age_range': card.ageRange,
      'handedness': card.handedness,
      'experience_years': card.experienceYears,
      'playable_positions': card.playablePositions,
      'desired_position': card.desiredPosition,
      'pitcher_availability': card.pitcherAvailability,
      'catcher_availability': card.catcherAvailability,
      'level': card.level,
      'blank_status': card.blankStatus,
      'glove_status': card.gloveStatus,
      'bat_status': card.batStatus,
      'spike_status': card.spikeStatus,
      'participation_style': card.participationStyle,
    });
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String displayName,
  }) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'display_name': displayName,
      },
    );
  }
}