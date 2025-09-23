import 'package:flutter/material.dart';
import '../models/user.dart';

class UserService extends ChangeNotifier {
  User? currentUser;
  List<Order> orders = [];
  final List<int> dailyCoinRewards = [5, 10, 15, 20, 25, 30, 50]; // Coin rewards for days 1-7
  bool hasClaimedToday = false;
  
  UserService() {
    // Data dummy user
    currentUser = User(
      name: "Najwa Chava Safiera",
      purchaseCount: 0,
      totalPoints: 50,
      claimedVouchers: [],
      dailyLoginCount: 0,
      email: "24111814118@mhs.unesa.ac.id",
    );
  }
  
  void addOrder(Order order) {
    orders.add(order);
    notifyListeners();
  }

  // Update login harian
  // Update login harian (no longer increments count directly)
  void updateDailyLogin() {
    hasClaimedToday = false;
    notifyListeners();
  }

  // Klaim koin harian
  int claimDailyCoin() {
    if (currentUser == null) return 0;
    final day = currentUser!.dailyLoginCount;
    if (day >= 7 || hasClaimedToday) return 0; // Only 7 days, only once per day
    final reward = dailyCoinRewards[day];
    currentUser!.totalPoints += reward;
    currentUser!.dailyLoginCount++;
    hasClaimedToday = true;
    notifyListeners();
    return reward;
  }

  // Get today's coin reward
  int getTodayCoinReward() {
    final day = currentUser?.dailyLoginCount ?? 0;
    if (day >= 7) return 0;
    return dailyCoinRewards[day];
  }

  // Cek apakah bisa klaim reward
  bool canClaimDailyReward() {
    return currentUser != null && currentUser!.dailyLoginCount < 7 && !hasClaimedToday;
  }

  // Reward berikutnya
  String getNextReward() {
    if (currentUser == null) return "Reward Tidak Tersedia";
    final day = currentUser!.dailyLoginCount;
    if (day >= 7) return "Reward sudah selesai!";
    return "Klaim ${dailyCoinRewards[day]} koin hari ini!";
  }

  // Klaim voucher
  void claimVoucher(String voucherName) {
    if (currentUser != null) {
      currentUser!.claimedVouchers.add(voucherName);
      notifyListeners();
    }
  }
}
