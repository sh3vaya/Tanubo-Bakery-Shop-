import 'package:flutter/material.dart';
import '../models/user.dart';

class UserService extends ChangeNotifier {
  User? currentUser;
  List<Order> orders = [];
  
  UserService() {
    // Data dummy user
    currentUser = User(
      name: "Sheva",
      purchaseCount: 0,
      totalPoints: 50,
      claimedVouchers: [],
      dailyLoginCount: 0,
      email: "sheva@gmail.com",
    );
  }
  
  void addOrder(Order order) {
    orders.add(order);
    notifyListeners();
  }

  // Update login harian
  void updateDailyLogin() {
    if (currentUser != null) {
      currentUser!.dailyLoginCount++;
      notifyListeners();
    }
  }

  // Cek apakah bisa klaim reward
  bool canClaimDailyReward() {
    return currentUser != null && currentUser!.dailyLoginCount >= 7;
  }

  // Reward berikutnya
  String getNextReward() {
    if (currentUser == null) return "Reward Tidak Tersedia";
    return currentUser!.dailyLoginCount < 7
        ? "Selesaikan login untuk reward!"
        : "Reward siap diklaim!";
  }

  // Klaim voucher
  void claimVoucher(String voucherName) {
    if (currentUser != null) {
      currentUser!.claimedVouchers.add(voucherName);
      notifyListeners();
    }
  }
}
