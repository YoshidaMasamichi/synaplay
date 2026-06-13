import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/supabase/supabase_client.dart';

class AuthService {
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