import 'package:supabase_flutter/supabase_flutter.dart';

String authErrorMessage(Object error, {required String action}) {
  if (error is AuthException) {
    return error.message;
  }

  final message = error.toString().toLowerCase();
  if (message.contains('failed host lookup') ||
      message.contains('socketexception') ||
      message.contains('no address associated with hostname')) {
    return 'ネットワークに接続できません。通信環境またはSupabaseのURLを確認して、もう一度お試しください。';
  }

  if (message.contains('clientexception')) {
    return '$actionに失敗しました。通信状態を確認して、もう一度お試しください。';
  }

  return '$actionに失敗しました。時間をおいて再度お試しください。';
}
