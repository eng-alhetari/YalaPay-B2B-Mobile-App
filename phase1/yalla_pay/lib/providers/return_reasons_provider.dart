import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReturnReasonsNotifier extends Notifier <List<String>>{
  @override
  List<String> build() {
    initialize();
    return [];
  }
  
  void initialize() async {
    var data = await rootBundle.loadString('assets/data/return-reasons.json');
    var reasonsMap = jsonDecode(data);
    List<String> reasons = [];
    reasonsMap.forEach((m) => reasons.add('$m'));
    state = reasons;
  }
}

final returnReasonsNotifierProvider = 
  NotifierProvider<ReturnReasonsNotifier, List<String>>(() => ReturnReasonsNotifier(),);