import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/supabase/supabase_client.dart';

class AuthService {
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