import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yalla_pay/model/cheque_deposit.dart';

class ChequeDepositNotifier extends Notifier<List<ChequeDeposit>> {
  int assignableID = 0;
  @override
  List<ChequeDeposit> build() {
    initializeDeposits();
    return [];
  }

  void initializeDeposits() async {
    String data = await rootBundle.loadString('assets/data/cheque-deposits.json');
    var depositsMap = jsonDecode(data);
    List<ChequeDeposit> deposits = [];
    depositsMap.forEach((map) => deposits.add(ChequeDeposit.fromJson(map)));
    for (var deposit in deposits){
      if (int.parse(deposit.id!) > assignableID){
        assignableID = int.parse(deposit.id!);
      }
    }
    state = deposits;
  }

  void addDeposit(ChequeDeposit deposit) {
    // Add a new deposit and update the state
    assignableID++;
    deposit.id = assignableID.toString();
    state = [...state, deposit];
  }

  void deleteDeposit(String id){
    state = state.where((d) => d.id != id).toList();
  }

  void updateDepositStatus(String id, String status){
    ChequeDeposit deposit = state.firstWhere((d) => d.id == id);

    deposit.status = status;

    for (var d in state){
      if (d.id == id){
        state[state.indexOf(d)] = deposit;
      }
    }

    var temp = state;
    state = [];
    state = temp;
  }

  void updateDepositCashedDate(String id, DateTime date){
    ChequeDeposit deposit = state.firstWhere((d) => d.id == id);

    deposit.cashedDate = date;

    for (var d in state){
      if (d.id == id){
        state[state.indexOf(d)] = deposit;
      }
    }

    var temp = state;
    state = [];
    state = temp;
  }

  // Example: Search deposits by bank account number
  List<ChequeDeposit> searchDepositsByAccount(String accountNo) {
    return state
        .where((deposit) =>
            deposit.bankAccountNo.toLowerCase().contains(accountNo.toLowerCase()))
        .toList();
  }

  // Example: Filter deposits by status
  List<ChequeDeposit> filterDepositsByStatus(String status) {
    return state.where((deposit) => deposit.status == status).toList();
  }
}

final chequeDepositNotifierProvider =
    NotifierProvider<ChequeDepositNotifier, List<ChequeDeposit>>(() => ChequeDepositNotifier());
