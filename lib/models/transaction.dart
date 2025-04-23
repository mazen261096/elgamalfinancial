class Transactions {
  late final String description;
  late final String name;
  late final String uId;
  late final DateTime createdAt;
  late final int amount;
  late final String category;
  late final String bill;
  late final String type;
  late final String walletName;

  Transactions.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    walletName = json['walletName'];
    amount = json['amount'];
    name = json['name'];
    uId = json['uId'];
    description = json['description'];
    createdAt = json['createdAt'];
    category = json['category'];
    bill = json['bill'];
  }
}
