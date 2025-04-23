class UserData {
  late final String id;

  late final String name;

  late final String email;

  late final String phoneNumber;

  late final String profilePic;

  late final String address;

  late final String token;

  late final bool isAdmin;

  late final bool disabled;

  late final bool deleted;

  late final List wallets;

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    profilePic = json['profilePic'];
    address = json['address'];
    token = json['token'];
    isAdmin = json['isAdmin'];
    disabled = json['disabled'];
    deleted = json['deleted'];
    wallets = json['wallets'];
  }
}
