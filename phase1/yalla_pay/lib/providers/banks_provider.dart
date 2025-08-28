import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BanksNotifier extends Notifier<List<String>>{
  @override
  List<String> build() {
    initialize();
    return [];
  }
  
  void initialize() async {
    var data = await rootBundle.loadString('assets/data/banks.json');
    var banksMap = jsonDecode(data);
    List<String> banks = [];
    banksMap.forEach((m) => banks.add('$m'));
    state = banks;
  }
}

final banksNotifierProvider = 
  NotifierProvider<BanksNotifier, List<String>>(() => BanksNotifier(),);