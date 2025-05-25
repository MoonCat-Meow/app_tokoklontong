import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_tokoklontong/screen/splash_screem.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mcvabhrtyeuodiunyxql.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1jdmFiaHJ0eWV1b2RpdW55eHFsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3NTIzODUsImV4cCI6MjA2MzMyODM4NX0.ilngLCn2UX_9UKMi3KLihIgzeFv008fOuHbV_6kCj70',
  );

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
