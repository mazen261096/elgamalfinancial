import 'package:moneytrack/models/transaction.dart';

class Wallet {
  late final String id;

  late final String name;

  late final String description;

  late final DateTime createdAt;

  late final int balance;

  late final int expenses;

  late final List<Transactions> transactions;

  late final List members;

  late final List viewers;

  late final List access;

  late final bool freezed;

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    createdAt = json['createdAt'];
    balance = json['balance'];
    expenses = json['expenses'];
    transactions = json['transactions'];
    members = json['members'];
    viewers = json['viewers'];
    access = json['access'];
    freezed = json['freezed'];
  }
}
