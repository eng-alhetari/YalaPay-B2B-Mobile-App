import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yalla_pay/model/payment.dart';

class PaymentNotifier extends Notifier<List<Payment>> {
  int assignablePaymentID = 0;
  @override
  List<Payment> build() {
    initializePayments();
    return [];
  }

  void initializePayments() async {
    String data = await rootBundle.loadString('assets/data/payments.json');
    var paymentsMap = jsonDecode(data) as List;
    List<Payment> payments = paymentsMap.map((map) => Payment.fromJson(map)).toList();

    for(var x in payments){
      if (int.parse(x.id!) > assignablePaymentID){
        assignablePaymentID = int.parse(x.id!);
      }
    }
    
    state = payments;
  }

  void addPayment(Payment payment) {
    assignablePaymentID++;
    payment.id = assignablePaymentID.toString();

    state = [...state, payment];
  }
  
  void deletePayment(String id){
    state = state.where((p) => p.id != id).toList();
  }

  void updatePayment(Payment payment){
    state[state.indexOf(state.firstWhere((p) => p.id == payment.id))] = payment;

    var temp = state;
    state = [];
    state = temp;
  }
  
  List<Payment> searchPaymentsByInvoice(String invoiceNo) {
    return state.where((payment) => payment.invoiceNo == invoiceNo).toList();
  }
  List<Payment> searchPaymentsByModeAndID(String invoiceNo, String query) {
    return state.where((payment) => (payment.invoiceNo == invoiceNo)
    && 
    (
      payment.paymentMode.toLowerCase().contains(query.toLowerCase())
    )).toList();
  }
}

final paymentNotifierProvider =
    NotifierProvider<PaymentNotifier, List<Payment>>(() => PaymentNotifier());
