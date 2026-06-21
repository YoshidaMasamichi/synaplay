import '../../../core/supabase/supabase_client.dart';

class ParticipationService {
  Future<List<Map<String, dynamic>>> fetchParticipants(
      String recruitmentId) async {
    final res = await supabase
        .from('recruitment_participants')
        .select()
        .eq('recruitment_id', recruitmentId)
        .order('created_at', ascending: true);
    return (res as List).cast<Map<String, dynamic>>();
  }

  Future<bool> isJoined(String recruitmentId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return false;
    final res = await supabase
        .from('recruitment_participants')
        .select()
        .eq('recruitment_id', recruitmentId)
        .eq('user_id', userId);
    return (res as List).isNotEmpty;
  }

  Future<void> join(String recruitmentId, String displayName) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('ログインが必要です');
    await supabase.from('recruitment_participants').insert({
      'recruitment_id': recruitmentId,
      'user_id': userId,
      'display_name': displayName,
    });
  }

  Future<void> cancel(String recruitmentId) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('ログインが必要です');
    await supabase
        .from('recruitment_participants')
        .delete()
        .eq('recruitment_id', recruitmentId)
        .eq('user_id', userId);
  }
}
