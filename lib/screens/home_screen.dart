import 'dart:async';
import 'vip_screen.dart';
import '../models/vip_level.dart';
import '../models/item.dart';
import 'menu_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Timer _timer;
  String _greeting = '';

  @override
  void initState() {
    super.initState();
    _updateGreeting();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateGreeting();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour >= 5 && hour < 12) {
      greeting = 'Selamat pagi';
    } else if (hour >= 12 && hour < 15) {
      greeting = 'Selamat siang';
    } else if (hour >= 15 && hour < 18) {
      greeting = 'Selamat sore';
    } else {
      greeting = 'Selamat malam';
    }

    setState(() {
      _greeting = greeting;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
  switch (_selectedIndex) {
    case 0:
      return _buildBeranda();
    case 1:
      return const MenuScreen(); // Tab menu
    case 2:
      return _buildVip(); // VIP pindah ke index 2
    case 3:
      return _buildProfil(); // Profile pindah ke index 3
    default:
      return _buildBeranda();
    }
  }

  Widget _buildBeranda() {
    return Center(
      child: Text(
        '$_greeting, User!',
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF5D4037), // warna coklat tua
        ),
      ),
    );
  }

  Widget _buildVip() {
  int userSpent = 800000; // Contoh total belanja user, ganti dengan data asli
  VipLevel userLevel;

  if (userSpent < 700000) {
    userLevel = SilverLevel();
  } else if (userSpent < 1400000) {
    userLevel = GoldLevel();
  } else {
    userLevel = DiamondLevel();
  }

  return VipPage(userTotalSpent: userSpent, userLevel: userLevel);
}

  Widget _buildProfil() {
    return const Center(
      child: Text(
        'Halaman Profil',
        style: TextStyle(fontSize: 24, color: Color(0xFF5D4037)),
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
        selectedItemColor: const Color(0xFF5D4037), // warna coklat tua
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'VIP',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}