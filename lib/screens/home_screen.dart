import 'package:tanubo/widgets/loyalty_card_widget.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanubo/services/user_service.dart';
import 'package:tanubo/screens/profile_screen.dart';
import 'package:tanubo/screens/menu_screen.dart';
import 'package:tanubo/screens/voucher_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Loyalty card state
  int _stampCount = 0;
  DateTime _promoEnd = DateTime(2025, 9, 30);
  String _loyaltyMessage = '';

  void _handleTransact() {
    final today = DateTime.now();
    if (today.isAfter(_promoEnd)) {
      setState(() {
        _loyaltyMessage = 'Promo sudah berakhir!';
      });
      return;
    }
    setState(() {
      _stampCount++;
      if (_stampCount == 7) {
        _loyaltyMessage = 'Selamat! Anda mendapatkan minuman gratis!';
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _stampCount = 0;
            _loyaltyMessage = '';
          });
        });
      } else {
        _loyaltyMessage = '';
      }
    });
  }
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
              LoyaltyCardWidget(
                stampCount: _stampCount,
                promoEnd: _promoEnd,
                onTransact: _handleTransact,
                promoActive: DateTime.now().isBefore(_promoEnd),
                message: _loyaltyMessage,
              ),
              const SizedBox(height: 24),
              _buildDailyRewardSection(userService),
              const SizedBox(height: 24),
              // _buildPointsSection(user) dihapus
              // const SizedBox(height: 24),
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

    final userService = Provider.of<UserService>(context, listen: false);
    final user = userService.currentUser;
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
                Row(
                  children: [
                    Text(userName,
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.monetization_on, color: Color(0xFFBCA177), size: 22),
                          const SizedBox(width: 4),
                          Text(
                            user != null ? '${user.totalPoints}' : '0',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFBCA177),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
    final todayCoin = userService.getTodayCoinReward();
    final claimed = !userService.canClaimDailyReward();
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Claim Koin Harian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            SizedBox(height: 12),
            LinearProgressIndicator(
              value: dailyLoginCount / 7,
              backgroundColor: Colors.grey[300],
              color: Color(0xFF5D4037),
              minHeight: 8,
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final isToday = i == dailyLoginCount;
                final isClaimed = i < dailyLoginCount;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isToday
                          ? Colors.yellow[100]
                          : isClaimed
                              ? Colors.grey[200]
                              : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isToday
                            ? Colors.orange
                            : Colors.grey[300]!,
                        width: isToday ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.monetization_on,
                            color: isToday ? Colors.orange : Color(0xFFBCA177), size: 22),
                        SizedBox(height: 4),
                        Text(
                          '${userService.dailyCoinRewards[i]}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isToday ? Colors.orange : Color(0xFF5D4037),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text('Hari ${i + 1}', style: TextStyle(fontSize: 11)),
                        if (isClaimed)
                          Text('✓', style: TextStyle(color: Colors.green, fontSize: 12)),
                      ],
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 12),
            (!claimed && todayCoin > 0)
                ? SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final reward = userService.claimDailyCoin();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Berhasil klaim $reward koin!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 225, 152, 34),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Klaim $todayCoin Koin Gratis!'),
                    ),
                  )
                : claimed
                    ? Center(
                        child: Text(
                          'Sudah diklaim hari ini!',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      )
                    : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }



  // === Akses Cepat (diubah jadi About Section untuk Bakery App) ===
  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tentang Aplikasi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4037),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFFFF8E1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Color(0xFFBCA177), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                children: [
                  Icon(Icons.cake, color: Color(0xFF5D4037)),
                  SizedBox(width: 8),
                  Text(
                    'Bakery Bliss App 🍰',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Bakery Bliss adalah aplikasi toko roti modern yang memudahkan '
                    'pelanggan dalam memesan kue, roti, dan pastry favorit secara cepat dan praktis. '
                    'Didesain dengan antarmuka yang sederhana dan hangat untuk pecinta bakery sejati!',
                style: TextStyle(fontSize: 13, color: Color(0xFF5D4037)),
              ),
              SizedBox(height: 8),
              Text(
                'Versi: 1.0.0',
                style: TextStyle(fontSize: 12, color: Colors.brown),
              ),
              Text(
                'Dikembangkan oleh Tim Bakery Dev',
                style: TextStyle(fontSize: 12, color: Colors.brown),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Removed unused _claimDailyReward method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5E9DA),
        iconTheme: const IconThemeData(color: Color(0xFF5D4037)),
        elevation: 2,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.asset('assets/images/logoo.png', fit: BoxFit.contain),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Tanubo',
              style: TextStyle(
                color: Color(0xFF5D4037),
                fontWeight: FontWeight.bold,
                fontSize: 22,
               // letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFBCA177),
        unselectedItemColor: const Color(0xFF8D6E63),
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