import 'package:flutter/material.dart';
import 'package:tanubo/models/vip_level.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/detail_screen.dart';
import 'screens/vip_screen.dart';
import 'screens/profile_screen.dart';
import 'models/item.dart';
import 'screens/menu_screen.dart';

void main() {
  runApp(TanuboApp());
}

class TanuboApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tanubo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/menu':(context) => MenuScreen(),
        '/vip': (context) {
          return VipPage(
            userTotalSpent: 800000,
            userLevel: GoldLevel()
            );
        },
        '/profile': (context) => ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final args = settings.arguments;
          if (args is Map<String, dynamic> && args['item'] is Item) {
            return MaterialPageRoute(
              builder: (context) {
                return DetailScreen(item: args['item']);
              },
            );
          }
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(child: Text('Argument tidak valid')),
            ),
          );
        }
        return null;
      },
    );
  }
}