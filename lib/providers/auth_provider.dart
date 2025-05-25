import 'package:app_tokoklontong/models/users.dart';
import 'package:get/get.dart';
import 'package:app_tokoklontong/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends GetxController {
  final AuthService _authService = AuthService();
  Rxn<UserModel> currentUser = Rxn<UserModel>();
  final supabase = Supabase.instance.client;

  Future<bool> registerUser({
    required String username,
    required String email,
    required String nohp,
    required String password,
  }) async {
    try {
      final data =
          await supabase
              .from('users')
              .insert({
                'username': username,
                'email': email,
                'nohp': nohp,
                'password': password,
              })
              .select()
              .single();

      print('Supabase insert data: $data');

      if (data != null) {
        print('Registrasi berhasil');
        return true;
      } else {
        print('Registrasi gagal, data kosong');
        return false;
      }
    } catch (e) {
      print('Error registerUser: $e');
      return false;
    }
  }

  Future<bool> loginUser({
    required String identity, // bisa username/email
    required String password,
  }) async {
    print('Attempt login with identity: $identity and password: $password');

    final userData = await _authService.login(
      identity: identity,
      password: password,
    );

    print('User data from login: $userData');

    if (userData != null) {
      currentUser.value = UserModel.fromJson(userData);
      return true;
    }
    return false;
  }

  void logout() {
    currentUser.value = null;
  }
}
