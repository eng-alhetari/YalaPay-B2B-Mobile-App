import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yalla_pay/model/bank_account.dart';

class BankAccountNotifier extends Notifier<List<BankAccount>> {
  @override
  List<BankAccount> build() {
    initializeBankAccounts();
    return [];
  }

  void initializeBankAccounts() async {
    String data = await rootBundle.loadString('assets/data/bank-accounts.json');
    var bankAccountsMap = jsonDecode(data);
    List<BankAccount> bankAccounts = [];
    for (var bankAccountMap in bankAccountsMap) {
      bankAccounts.add(BankAccount.fromJson(bankAccountMap));
    }
    state = bankAccounts;
  }

}

final bankAccountNotifierProvider =
    NotifierProvider<BankAccountNotifier, List<BankAccount>>(() => BankAccountNotifier());