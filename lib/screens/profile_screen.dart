// screens/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int currentDay = 2; // Hari ke-2 (contoh)
  bool biometricEnabled = false;
  bool tutorialCompleted = true;
  String selectedLanguage = 'Indonesia';

  // Data untuk daily check-in
  final List<Map<String, dynamic>> checkInDays = [
    {'day': 1, 'completed': true, 'reward': '+25', 'isVoucher': false},
    {'day': 2, 'completed': true, 'reward': '+25', 'isVoucher': false},
    {'day': 3, 'completed': false, 'reward': 'Voucher', 'isVoucher': true},
    {'day': 4, 'completed': false, 'reward': '+25', 'isVoucher': false},
    {'day': 5, 'completed': false, 'reward': '+25', 'isVoucher': false},
    {'day': 6, 'completed': false, 'reward': 'Voucher', 'isVoucher': true},
    {'day': 7, 'completed': false, 'reward': 'Voucher', 'isVoucher': true},
  ];

  // Fungsi untuk format tanggal tanpa package intl
  String formatDate(DateTime date) {
    return '${date.day} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Profil Saya'),
        backgroundColor: Color(0xFF5D4037),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily Check-In Section
            _buildDailyCheckIn(),
            SizedBox(height: 24),
            
            // Account Section
            _buildAccountSection(),
            SizedBox(height: 24),
            
            // Order Section
            _buildOrderSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyCheckIn() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daily Check-In',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5D4037),
                  ),
                ),
                Text(
                  'Berakhir ${formatDate(DateTime(2025, 9, 30))}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Check-in days grid
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.9,
              ),
              itemCount: checkInDays.length,
              itemBuilder: (context, index) {
                final day = checkInDays[index];
                final isCurrent = index + 1 == currentDay;
                final isCompleted = day['completed'] as bool;
                final isVoucher = day['isVoucher'] as bool;
                
                return Container(
                  decoration: BoxDecoration(
                    color: isCurrent ? Color(0xFF5D4037) : 
                           isCompleted ? Colors.green[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day['reward'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? Colors.white : 
                                 isVoucher ? Colors.orange : Color(0xFF5D4037),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Hari ke-${day['day']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isCurrent ? Colors.white : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Show details
                },
                child: Text(
                  'Detail',
                  style: TextStyle(
                    color: Color(0xFF5D4037),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Akun',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4037),
          ),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildListTile(
                icon: Icons.email,
                title: 'Kotak Masuk',
                onTap: () {},
              ),
              Divider(height: 1),
              _buildListTile(
                icon: Icons.location_on,
                title: 'Alamat Pengiriman',
                onTap: () {},
              ),
              Divider(height: 1),
              _buildListTile(
                icon: Icons.qr_code_scanner,
                title: 'Scan Merchandise',
                onTap: () {},
              ),
              Divider(height: 1),
              _buildListTile(
                icon: Icons.fingerprint,
                title: 'Aktifkan Biometric ID',
                trailing: Switch(
                  value: biometricEnabled,
                  onChanged: (value) {
                    setState(() {
                      biometricEnabled = value;
                    });
                  },
                  activeColor: Color(0xFF5D4037),
                ),
                onTap: () {
                  setState(() {
                    biometricEnabled = !biometricEnabled;
                  });
                },
              ),
              Divider(height: 1),
              _buildListTile(
                icon: Icons.language,
                title: 'Ubah Bahasa Aplikasi',
                trailing: Text(
                  selectedLanguage,
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  _showLanguageDialog();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pesan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5D4037),
          ),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildListTile(
                icon: Icons.history,
                title: 'Riwayat Pesanan',
                onTap: () {},
              ),
              Divider(height: 1),
              _buildListTile(
                icon: Icons.shopping_cart,
                title: 'Order menggunakan apps',
                onTap: () {},
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                tutorialCompleted = false;
              });
              // Navigate to tutorial
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFF5D4037),
              side: BorderSide(color: Color(0xFF5D4037)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Ulangi Tutorial'),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Color(0xFF5D4037),
        size: 24,
      ),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih Bahasa'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Indonesia'),
                leading: Radio<String>(
                  value: 'Indonesia',
                  groupValue: selectedLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      selectedLanguage = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: Text('English'),
                leading: Radio<String>(
                  value: 'English',
                  groupValue: selectedLanguage,
                  onChanged: (String? value) {
                    setState(() {
                      selectedLanguage = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}