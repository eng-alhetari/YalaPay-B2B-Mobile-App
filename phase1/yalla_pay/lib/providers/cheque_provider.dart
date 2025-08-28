import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yalla_pay/model/cheque.dart';

class ChequeNotifier extends Notifier<List<Cheque>> {

  int assignableChequeNo = 0;

  @override
  List<Cheque> build() {
    initializeCheques();
    return [];
  }

  void initializeCheques() async {
    String data = await rootBundle.loadString('assets/data/cheques.json');
    var chequesMap = jsonDecode(data) as List;
    List<Cheque> cheques = chequesMap.map((map) => Cheque.fromJson(map)).toList();

    for (var c in cheques){
      if (c.chequeNo! > assignableChequeNo){
        assignableChequeNo = c.chequeNo!;
      }
    }

    state = cheques;
  }

  int addCheque(Cheque cheque) {
    assignableChequeNo++;
    cheque.chequeNo = assignableChequeNo;
    state = [...state, cheque];
    return assignableChequeNo;
  }

  void deleteCheque(int chequeNo){
    state = state.where((c) => c.chequeNo != chequeNo).toList();
  }

  void updateChequeStatus(int chequeNo, String status){
    Cheque cheque = state.firstWhere((c) => c.chequeNo == chequeNo);

    cheque.status = status;

    for (var c in state){
      if (c.chequeNo == chequeNo){
        state[state.indexOf(c)] = cheque;
      }
    }

    var temp = state;
    state = [];
    state = temp;
  }

  void updateChequeReturnReason(int chequeNo, String reason){
    Cheque cheque = state.firstWhere((c) => c.chequeNo == chequeNo);

    cheque.returnReason = reason;

    for (var c in state){
      if (c.chequeNo == chequeNo){
        state[state.indexOf(c)] = cheque;
      }
    }

    var temp = state;
    state = [];
    state = temp;
  }

  void updateChequeCashedDate(int chequeNo, DateTime date){
    Cheque cheque = state.firstWhere((c) => c.chequeNo == chequeNo);

    cheque.cashedDate = date;

    for (var c in state){
      if (c.chequeNo == chequeNo){
        state[state.indexOf(c)] = cheque;
      }
    }

    var temp = state;
    state = [];
    state = temp;
  }

  void updateChequeDetails(Cheque cheque){
    state[state.indexOf(state.firstWhere((c) => c.chequeNo == cheque.chequeNo))] = cheque;

    var temp = state;
    state = [];
    state = temp;
  }

  List<Cheque> searchChequesByBank(String bankName) {
    return state
        .where((cheque) =>
            cheque.bankName.toLowerCase().contains(bankName.toLowerCase()))
        .toList();
  }

  List<Cheque> filterChequesByStatus(String status) {
    return state.where((cheque) => cheque.status == status).toList();
  }
}

final chequeNotifierProvider =
    NotifierProvider<ChequeNotifier, List<Cheque>>(() => ChequeNotifier());
