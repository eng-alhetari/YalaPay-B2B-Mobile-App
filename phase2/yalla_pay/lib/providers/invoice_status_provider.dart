import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoiceStatusNotifier extends Notifier<List<String>>{
  @override
  List<String> build() {
    initialize();
    return [];
  }
  
  void initialize() async {
    var data = await rootBundle.loadString('assets/data/invoice-status.json');
    var statusMap = jsonDecode(data);
    List<String> status = [];
    statusMap.forEach((m) => status.add('$m'));
    state = status;
  }
}

final invoiceStatusNotifierProvider = 
  NotifierProvider<InvoiceStatusNotifier, List<String>>(() => InvoiceStatusNotifier(),);