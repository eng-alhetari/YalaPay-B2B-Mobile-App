import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentModeNotifier extends Notifier <List<String>>{
 @override
  List<String> build() {
    initialize();
    return [];
  }
  
  void initialize() async {
    var data = await rootBundle.loadString('assets/data/payment-modes.json');
    var modesMap = jsonDecode(data);
    List<String> modes = [];
    modesMap.forEach((m) => modes.add('$m'));
    state = modes;
  }
}

final paymentModeNotifierProvider = 
  NotifierProvider<PaymentModeNotifier, List<String>>(() => PaymentModeNotifier(),);