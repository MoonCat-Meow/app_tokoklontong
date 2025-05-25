// import 'package:app_tokoklontong/screen/home_screen.dart';
import 'package:app_tokoklontong/screen/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:app_tokoklontong/screen/login_screen.dart';
import 'package:app_tokoklontong/screen/profile_screen.dart';
import 'package:app_tokoklontong/providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 2; // Home

  final iconList = <IconData>[
    Icons.inventory_2, // Produk
    Icons.receipt_long, // Transaksi
    Icons.bar_chart, // Laporan
    Icons.person, // Akun
  ];

  late final List<Widget> pages;
  final AuthProvider authProvider = Get.find<AuthProvider>();

  @override
  void initState() {
    super.initState();
    pages = [
      ProductScreen(),
      const Placeholder(child: Text('Halaman Transaksi')),
      // Home Page
      _buildHomePage(),
      const Placeholder(child: Text('Halaman Laporan')),
      // Profile Page
      ProfileScreen(),
    ];
  }

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Obx(() {
            final user = authProvider.currentUser.value;
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade400, Colors.teal.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      user?.username ?? 'User',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toko Babe',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          // Quick Actions
          Text(
            'Menu Utama',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildMenuCard(
                  icon: Icons.inventory_2,
                  title: 'Produk',
                  color: Colors.blue,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _buildMenuCard(
                  icon: Icons.receipt_long,
                  title: 'Transaksi',
                  color: Colors.green,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _buildMenuCard(
                  icon: Icons.bar_chart,
                  title: 'Laporan',
                  color: Colors.orange,
                  onTap: () => setState(() => _currentIndex = 3),
                ),
                _buildMenuCard(
                  icon: Icons.person,
                  title: 'Profil',
                  color: Colors.purple,
                  onTap: () => setState(() => _currentIndex = 4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logout() {
    authProvider.logout();
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
      body: pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () => setState(() => _currentIndex = 2),
        backgroundColor: Colors.teal,
        elevation: 8,
        child: const Icon(Icons.home, size: 28, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _currentIndex < 2 ? _currentIndex : _currentIndex - 1,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 0,
        rightCornerRadius: 0,
        activeColor: Colors.white,
        inactiveColor: Colors.grey.shade400,
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
