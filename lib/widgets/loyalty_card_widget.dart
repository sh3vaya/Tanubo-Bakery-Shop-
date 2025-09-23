import 'package:flutter/material.dart';

class LoyaltyCardWidget extends StatelessWidget {
  final int stampCount;
  final DateTime promoEnd;
  final VoidCallback onTransact;
  final bool promoActive;
  final String message;

  const LoyaltyCardWidget({
    Key? key,
    required this.stampCount,
    required this.promoEnd,
    required this.onTransact,
    required this.promoActive,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gratis Roti', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
        SizedBox(height: 6),
        Text('Berakhir sampai ${promoEnd.day} ${_monthName(promoEnd.month)} ${promoEnd.year}', style: TextStyle(color: Color(0xFF8D6E63))),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (i) {
            final isClaimed = i < stampCount;
            final isGratis = i == 6;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isGratis
                        ? Color(0xFFFFD700)
                        : isClaimed
                            ? Color(0xFFFFE0B2)
                            : Colors.white,
                    border: Border.all(
                      color: isGratis
                          ? Color(0xFFFFD700)
                          : isClaimed
                              ? Color(0xFF388E3C)
                              : Color(0xFFBCA177),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: isGratis
                        ? Icon(Icons.breakfast_dining, color: Colors.white, size: 28)
                        : Icon(Icons.check_circle_outline, color: Color(0xFFBCA177), size: 28),
                  ),
                ),
                SizedBox(height: 6),
                isGratis
                    ? Text('Gratis', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 13))
                    : Text('Stamp ${i+1}', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFBCA177), fontWeight: FontWeight.bold, fontSize: 13)),
                SizedBox(height: 4),
                if (isClaimed && !isGratis)
                  Icon(Icons.check_circle, color: Color(0xFF388E3C), size: 18),
              ],
            );
          }),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: promoActive ? onTransact : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFBCA177),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Transaksi'),
        ),
        if (message.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(message, style: TextStyle(color: Color(0xFF388E3C), fontSize: 16)),
          ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month];
  }
}
