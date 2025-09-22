import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tanubo/screens/profile_screen.dart';
import 'package:tanubo/screens/menu_screen.dart';

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
        return const MenuScreen();
      case 2:
        return _buildPlaceholderScreen('VIP Screen'); // Ganti dengan placeholder
      case 3:
        return ProfileScreen();
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
          color: Color(0xFF5D4037),
        ),
      ),
    );
  }

  Widget _buildPlaceholderScreen(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF5D4037),
        ),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
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