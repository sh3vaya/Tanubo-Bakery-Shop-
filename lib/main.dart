import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:getwidget/getwidget.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/menu_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/cart_screen.dart';
import 'services/cart_service.dart';
import 'services/user_service.dart';

void main() {
  runApp(const TanuboApp());
}

class TanuboApp extends StatelessWidget {
  const TanuboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => UserService()),
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
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/menu': (context) => const MenuScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/cart': (context) => const CartScreen(),
          '/getwidget-demo': (context) => const GetWidgetDemo(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class GetWidgetDemo extends StatefulWidget {
  const GetWidgetDemo({super.key});

  @override
  _GetWidgetDemoState createState() => _GetWidgetDemoState();
}

class _GetWidgetDemoState extends State<GetWidgetDemo> {
  final String _playStoreLink =
      'https://play.google.com/store/apps/details?id=dev.getflutter.appkit';
  final String _githuAppRepoLink =
      'https://github.com/ionicfirebaseapp/getwidget-app-kit';
  final String _githubLibraryRepoLink =
      'https://github.com/ionicfirebaseapp/getwidget';

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GFColors.DARK,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              _launchUrl(_githubLibraryRepoLink);
            },
            child: SvgPicture.asset('assets/logo.svg'),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Center(
                  child: Text(
                    'To keep library size small and code clean we manage example on different repository. which includes clear usage of each and every component that we provide in GetWidget library. Please have a look there.',
                    style: TextStyle(
                      fontSize: 16,
                      color: GFColors.WHITE,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              GFButton(
                size: GFSize.LARGE,
                text: 'View on Github',
                textStyle: const TextStyle(
                  fontSize: 16,
                  color: GFColors.WHITE,
                ),
                icon: SvgPicture.asset(
                  'assets/github.svg',
                  height: 22,
                ),
                color: GFColors.SUCCESS,
                blockButton: true,
                onPressed: () {
                  _launchUrl(_githuAppRepoLink);
                },
              ),
            ],
          ),
          Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(bottom: 25),
                child: Center(
                  child: Text(
                    'We also have same app on playstore. It shows various possibilities that you can achieve using GetWidget library.',
                    style: TextStyle(
                      fontSize: 16,
                      color: GFColors.WHITE,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              GFButton(
                size: GFSize.LARGE,
                text: 'View on Playstore',
                textStyle: const TextStyle(fontSize: 16, color: GFColors.WHITE),
                icon: SvgPicture.asset(
                  'assets/playstore.svg',
                  height: 20,
                ),
                color: GFColors.SUCCESS,
                blockButton: true,
                onPressed: () {
                  _launchUrl(_playStoreLink);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}