import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'package:app_tokoklontong/screen/login_screen.dart';
import 'package:app_tokoklontong/screen/dashboard_home.dart'; // pastikan file ini ada

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 2; // Home di tengah (index ke-2)

  final iconList = <IconData>[
    Icons.inventory_2, // Produk
    Icons.receipt_long, // Transaksi
    Icons.bar_chart, // Laporan
    Icons.person, // Akun
  ];

  final List<Widget> pages = [
    const Placeholder(child: Text('Halaman Produk')),
    const Placeholder(child: Text('Halaman Transaksi')),
    const DashboardHome(), // Halaman Home
    const Placeholder(child: Text('Halaman Laporan')),
    const Placeholder(child: Text('Halaman Akun')),
  ];

  void _logout() {
    Get.offAll(() => const LoginScreen());
    Get.snackbar(
      'Logout',
      'Anda berhasil logout',
      backgroundColor: Colors.green.shade300,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko Kelontong Makmur'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: pages[_currentIndex],
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: () => setState(() => _currentIndex = 2), // Home
          backgroundColor: Colors.green,
          elevation: 8,
          child: const Icon(Icons.home, size: 28),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _currentIndex < 2 ? _currentIndex : _currentIndex - 1,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 0, // ubah ini jadi 0
        rightCornerRadius: 0, // ubah ini jadi 0
        activeColor: Colors.white,
        inactiveColor: Colors.grey,
        backgroundColor: Colors.teal,
        iconSize: 28,
        onTap: (index) {
          int actualIndex = index < 2 ? index : index + 1;
          setState(() => _currentIndex = actualIndex);
        },
      ),
    );
  }
}
