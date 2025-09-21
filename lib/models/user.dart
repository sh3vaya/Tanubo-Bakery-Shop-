import 'vip_level.dart';

class User {
  final String name;
  final String email;
  final String phone;
  final DateTime birthDate;
  final int transactionCount;
  int points;
  final VipLevel vipLevel;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.birthDate,
    required this.transactionCount,
    required this.points,
    required this.vipLevel,
  });
  User addTrnsacton(){
    return User(
      name: name,
      email: email,
      phone: phone,
      birthDate: birthDate,
      transactionCount: transactionCount + 1,
      points: points,
      vipLevel: vipLevel,
    );
  }
  User upgradeLevel(VipLevel newLevel){
    return User(
      name: name, 
      email: email, 
      phone: phone, 
      birthDate: birthDate, 
      transactionCount: transactionCount, 
      points: points, 
      vipLevel: vipLevel
      );
  }
}