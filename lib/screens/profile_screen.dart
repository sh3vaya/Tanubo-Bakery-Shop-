import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/vip_level.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User user;

  @override
void initState() {
  super.initState();
  user = User(
    name: 'Budi',
    email: 'budi@example.com',
    phone: '08123456789',
    birthDate: DateTime(1990, 5, 20),
    transactionCount: 10,
    points: 100,
    vipLevel: GoldLevel(), // gunakan subclass GoldLevel
  );
}

  void dailyCheckIn() {
    setState(() {
      user.points += 5;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Daily check-in berhasil! +5 poin')),
    );
  }

  void logout() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
            tooltip: 'Logout',
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Level Lencana: ${user.vipLevel.name} ${user.vipLevel.badge}'),
              subtitle: Text(user.vipLevel.benefits),
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text(user.email),
              subtitle: Text('Email'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text(user.phone),
              subtitle: Text('Nomor Handphone'),
            ),
            ListTile(
              leading: Icon(Icons.cake),
              title: Text('${user.birthDate.day}-${user.birthDate.month}-${user.birthDate.year}'),
              subtitle: Text('Tanggal Lahir'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Level Lencana: ${user.vipLevel.name} ${user.vipLevel.badge}'),
              subtitle: Text(user.vipLevel.benefits),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Transaksi: ${user.transactionCount} kali'),
            ),
            ListTile(
              leading: Icon(Icons.point_of_sale),
              title: Text('Poin: ${user.points}'),
            ),
            ElevatedButton(
              onPressed: dailyCheckIn,
              child: Text('Daily Check-in'),
            ),
          ],
        ),
      ),
    );
  }
}