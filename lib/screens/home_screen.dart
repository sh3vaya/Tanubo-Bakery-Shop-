import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanubo/services/user_service.dart';
import 'package:tanubo/screens/profile_screen.dart';
import 'package:tanubo/screens/menu_screen.dart';
import 'package:tanubo/screens/voucher_screen.dart';
import '../models/user.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Timer _timer;
  String _greeting = '';
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _updateGreeting();
    _updateCurrentTime();

    // Update daily login
    final userService = Provider.of<UserService>(context, listen: false);
    userService.updateDailyLogin();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateGreeting();
      _updateCurrentTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    setState(() {
      if (hour >= 5 && hour < 12) {
        _greeting = 'Selamat pagi';
      } else if (hour >= 12 && hour < 15) {
        _greeting = 'Selamat siang';
      } else if (hour >= 15 && hour < 18) {
        _greeting = 'Selamat sore';
      } else {
        _greeting = 'Selamat malam';
      }
    });
  }

  void _updateCurrentTime() {
    setState(() {
      _currentTime =
          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}';
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // === Body utama ===
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildBeranda();
      case 1:
        return const MenuScreen();
      case 2:
        return const ProfileScreen();
      default:
        return _buildBeranda();
    }
  }

  // === Halaman Beranda ===
  Widget _buildBeranda() {
    return Consumer<UserService>(
      builder: (context, userService, child) {
        final user = userService.currentUser;
        if (user == null) {
          return Center(child: Text('User belum tersedia'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(user.name),
              const SizedBox(height: 24),
              _buildDailyRewardSection(userService),
              const SizedBox(height: 24),
              _buildPurchaseSection(user),
              const SizedBox(height: 24),
              _buildPointsSection(user),
              const SizedBox(height: 24),
              _buildQuickActionsSection(),
            ],
          ),
        );
      },
    );
  }

  // === Header: Salam, Nama, Waktu ===
  Widget _buildHeaderSection(String userName) {
    final hour = DateTime.now().hour;
    IconData greetingIcon;

    if (hour >= 5 && hour < 12) {
      greetingIcon = Icons.wb_sunny_rounded;
    } else if (hour >= 12 && hour < 18) {
      greetingIcon = Icons.wb_cloudy_rounded;
    } else {
      greetingIcon = Icons.nights_stay_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF5D4037).withOpacity(0.9),
            const Color(0xFF8D6E63).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(greetingIcon, size: 36, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$_greeting,',
                    style: const TextStyle(fontSize: 20, color: Colors.white70)),
                Text(userName,
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text(_currentTime,
                    style: const TextStyle(fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // === Daily Reward ===
  Widget _buildDailyRewardSection(UserService userService) {
    final dailyLoginCount = userService.currentUser?.dailyLoginCount ?? 0;
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔄 Daily Login Reward',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: dailyLoginCount / 7,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFF5D4037),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hari ke-$dailyLoginCount dari 7',
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  userService.getNextReward(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: userService.canClaimDailyReward()
                        ? Colors.green
                        : const Color(0xFF5D4037),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (userService.canClaimDailyReward())
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _claimDailyReward(context, userService);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Klaim Reward Gratis!'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // === Statistik Pembelian ===
  Widget _buildPurchaseSection(User user) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📊 Statistik Pembelian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Hari Ini', '${user.purchaseCount}x'),
                _buildStatItem('Total', '${user.totalPoints} pts'),
                _buildStatItem(
                    'Reward', user.claimedVouchers.length.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4037),
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  // === Points ===
  Widget _buildPointsSection(User user) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '⭐ Points Anda',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${user.totalPoints} Points',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tukar points dengan voucher spesial!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // === Akses Cepat ===
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🚀 Akses Cepat',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4037),
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3,
          children: [
            _buildQuickActionButton('Belanja Sekarang', Icons.shopping_cart, () {
              _onItemTapped(1);
            }),
            _buildQuickActionButton('Lihat Voucher', Icons.confirmation_number,
                () {
              final userService = Provider.of<UserService>(context, listen: false);
              if (userService.currentUser != null) {
                // Tambahkan voucher dummy jika belum ada
                if (userService.currentUser!.claimedVouchers.isEmpty) {
                  userService.currentUser!.claimedVouchers.add('Voucher Diskon 10%');
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VoucherScreen()),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
      String text, IconData icon, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(text, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF5D4037),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF5D4037)),
        ),
      ),
    );
  }

  void _claimDailyReward(BuildContext context, UserService userService) {
    userService.claimVoucher('Reward Harian Gratis');
    if (userService.currentUser != null) {
      userService.currentUser!.totalPoints += 100;
      userService.currentUser!.dailyLoginCount = 0;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎉 Selamat! Anda mendapatkan minuman gratis!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tanubo'),
        backgroundColor: const Color(0xFF5D4037),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF5D4037),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

}
