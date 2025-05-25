import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<bool> register({
    required String username,
    required String email,
    required String nohp,
    required String password,
  }) async {
    try {
      final response = await _client.from('users').insert({
        'username': username,
        'email': email,
        'nohp': nohp,
        'password': password,
      });

      return response != null;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> login({
    required String identity,
    required String password,
  }) async {
    try {
      final userByUsername =
          await _client
              .from('users')
              .select()
              .eq('username', identity)
              .eq('password', password)
              .maybeSingle();

      if (userByUsername != null) {
        return userByUsername;
      }

      final userByEmail =
          await _client
              .from('users')
              .select()
              .eq('email', identity)
              .eq('password', password)
              .maybeSingle();

      return userByEmail;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }
}
