import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DepositStatusNotifier extends Notifier <List<String>> {
  @override
  List<String> build() {
    initialize();
    return [];
  }

  void initialize() async{
    var data = await rootBundle.loadString('assets/data/deposit-status.json');
    var statusMap = jsonDecode(data);
    List<String> status = [];
    statusMap.forEach((m) => status.add('$m'));
    state = status;
  }
}

final depositStatusNotifierProvider = NotifierProvider<DepositStatusNotifier, List<String>>(() => DepositStatusNotifier(),);