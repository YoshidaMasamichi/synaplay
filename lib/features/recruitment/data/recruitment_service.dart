import '../../../core/supabase/supabase_client.dart';
import '../domain/recruitment.dart';

class RecruitmentService {
  Future<List<Recruitment>> fetchAll() async {
    final res = await supabase
        .from('recruitments')
        .select()
        .order('date', ascending: true);
    return (res as List).map((e) => Recruitment.fromJson(e)).toList();
  }

  Future<void> create(Recruitment recruitment) async {
    await supabase.from('recruitments').insert(recruitment.toJson());
  }
}
