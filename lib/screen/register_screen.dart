import 'package:app_tokoklontong/providers/auth_provider.dart';
import 'package:app_tokoklontong/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _nohpController = TextEditingController();
  final _passwordController = TextEditingController();

  final AuthProvider authProvider = Get.put(AuthProvider());

  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final success = await authProvider.registerUser(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        nohp: _nohpController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (success) {
        Get.snackbar(
          'Berhasil',
          'Registrasi berhasil! Silakan login.',
          backgroundColor: Colors.green.shade300,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.off(() => const LoginScreen());
      } else {
        Get.snackbar(
          'Gagal',
          'Registrasi gagal!',
          backgroundColor: Colors.red.shade300,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/TokoBabe2D.png',
                    height: 250,
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Registrasi Akun',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                labelText: 'Username',
                                border: OutlineInputBorder(),
                              ),
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? 'Username tidak boleh kosong'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                labelText: 'Email',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? 'Email tidak boleh kosong'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _nohpController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                labelText: 'No. HP',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                              validator:
                                  (value) =>
                                      value!.isEmpty
                                          ? 'No. HP tidak boleh kosong'
                                          : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock),
                                labelText: 'Password',
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                              validator:
                                  (value) =>
                                      value!.length < 6
                                          ? 'Password minimal 6 karakter'
                                          : null,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  backgroundColor: Colors.blue.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'DAFTAR',
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 1.2,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  () => Get.off(() => const LoginScreen()),
                              child: const Text(
                                'Sudah punya akun? Login',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
