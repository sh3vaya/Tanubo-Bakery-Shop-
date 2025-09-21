import 'package:flutter/material.dart';
import '../models/vip_level.dart';

class VipPage extends StatelessWidget {
  final int userTotalSpent;
  final VipLevel userLevel;

  const VipPage({super.key, required this.userTotalSpent, required this.userLevel});

  VipLevel? get nextLevel {
    if (userLevel is SilverLevel) return GoldLevel();
    if (userLevel is GoldLevel) return DiamondLevel();
    return null; // Diamond adalah level tertinggi
  }

  double get progressToNextLevel {
    if (nextLevel == null) return 1.0;
    final requirement = nextLevel!.nextLevelRequirement;
    if (requirement == 0) return 1.0;
    return (userTotalSpent / requirement).clamp(0, 1);
  }

  String formatCurrency(int amount) {
    return 'Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final nextLvl = nextLevel;
    final progressPercent = (progressToNextLevel * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('VIP Level'),
        backgroundColor: const Color(0xFF5D4037),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Level Anda: ${userLevel.name}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Total belanja: ${formatCurrency(userTotalSpent)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),

            if (nextLvl != null) ...[
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: const Color(0xFFFFF3E0),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Syarat naik ke level ${nextLvl.name}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF5D4037),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Belanja minimal: ${formatCurrency(nextLvl.nextLevelRequirement)}',
                        style: TextStyle(fontSize: 16), // hapus const
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progressToNextLevel,
                        color: const Color(0xFF5D4037),
                        backgroundColor: Colors.grey[300],
                        minHeight: 10,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Progress: $progressPercent%',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ] else ...[
              const Text(
                'Anda sudah berada di level tertinggi!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5D4037),
                ),
              ),
              const SizedBox(height: 24),
            ],

            Text(
              'Persentase pembayaran yang sudah dilakukan:',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: (userTotalSpent / 1000000).clamp(0, 1),
              color: const Color(0xFF5D4037),
              backgroundColor: Colors.grey[300],
              minHeight: 10,
            ),
            const SizedBox(height: 16),

            Text(
              'Voucher',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 8),
            ...userLevel.vouchers.map((v) => ListTile(
                  leading: const Icon(Icons.local_offer, color: Color(0xFF5D4037)),
                  title: Text(v),
                )).toList(),

            const SizedBox(height: 16),
            Text(
              'Benefit',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Color(0xFF5D4037)),
                  title: Text(userLevel.benefits),
            )
          ],
        ),
      ),
    );
  }
}