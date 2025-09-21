abstract class VipLevel {
  String get name;
  String get badge; // misal emoji atau string badge
  List<String> get vouchers;
  String get benefits; // deskripsi benefit
  int get nextLevelRequirement;

  // contoh getter default
  String get benefitsDescription => benefits;
}

class SilverLevel extends VipLevel {
  @override
  String get name => 'Silver';

  @override
  String get badge => '🥈';

  @override
  List<String> get vouchers => ['Diskon 5%', 'Voucher ongkir Rp 10.000'];

  @override
  String get benefits => 'Voucher diskon saja';

  @override
  int get nextLevelRequirement => 7000000;
}

class GoldLevel extends VipLevel {
  @override
  String get name => 'Gold';

  @override
  String get badge => '🥇';

  @override
  List<String> get vouchers => ['Diskon 10%', 'Voucher ongkir Rp 20.000'];

  @override
  String get benefits => 'Diskon 10% dan potongan cake gratis';

  @override
  int get nextLevelRequirement => 1400000;
}

class DiamondLevel extends VipLevel {
  @override
  String get name => 'Diamond';

  @override
  String get badge => '💎';

  @override
  List<String> get vouchers => ['Diskon 15%', 'Voucher ongkir gratis'];

  @override
  String get benefits => 'Diskon 15%, cashback, dan promo eksklusif';

  @override
  int get nextLevelRequirement => 0;
}