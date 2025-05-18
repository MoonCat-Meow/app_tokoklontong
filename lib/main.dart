import 'package:app_tokoklontong/screen/splash_screem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app_tokoklontong/screen/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Toko BABE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const SplashScreen(),
    );
  }
}
