import 'package:tanubo/models/vip_level.dart';

class User {
  String name;
  String email;
  String phone;
  DateTime birthDate;
  String gender;
  int transactionCount;
  int points;
  VipLevel vipLevel;
  List<String> vouchers;
  String language;
  List<String> redeemCodes;
  String? address;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.gender,
    required this.transactionCount,
    required this.points,
    required this.vipLevel,
    required this.vouchers,
    required this.language,
    required this.redeemCodes,
    this.address,
  });

  // Method untuk mengcopy user dengan data baru
  User copyWith({
    String? name,
    String? email,
    String? phone,
    DateTime? birthDate,
    String? gender,
    String? address,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      transactionCount: this.transactionCount,
      points: this.points,
      vipLevel: this.vipLevel,
      vouchers: this.vouchers,
      language: this.language,
      redeemCodes: this.redeemCodes,
      address: address ?? this.address,
    );
  }
}