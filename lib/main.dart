import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/cart_screen.dart';
import 'services/cart_service.dart';

void main() {
  runApp(TanuboApp());
}

class TanuboApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
      ],
      child: MaterialApp(
        title: 'Tanubo Bakery',
        theme: ThemeData(
          primarySwatch: Colors.brown,
          fontFamily: 'Poppins',
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/menu': (context) => MenuScreen(),
          '/profile': (context) => ProfileScreen(),
          '/cart': (context) => CartScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}