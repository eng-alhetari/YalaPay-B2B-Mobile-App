import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yalla_pay/model/invoice.dart';

class InvoiceNotifier extends Notifier<List<Invoice>> {
  int assignableInvoiceID = 0;
  @override
  List<Invoice> build() {
    initializeInvoices();
    return [];
  }

  void initializeInvoices() async {
    
    String data = await rootBundle.loadString('assets/data/invoices.json');
    
    var invoicesMap = jsonDecode(data) as List;
    
    List<Invoice> invoices = invoicesMap.map((map) => Invoice.fromJson(map)).toList();

    for (var element in invoices) {
      if (int.parse(element.id!) > assignableInvoiceID){
        assignableInvoiceID = int.parse(element.id!);
      }
    }

    state = invoices;
  }

  void addInvoice({
    required String customerName,
    required String customerId, 
    required double amount,
    required DateTime invoiceDate,
    required DateTime dueDate}) {
    
    Invoice invoice = Invoice(
      id: (assignableInvoiceID + 1).toString(),
      customerId: customerId,
      customerName: customerName,
      amount: amount,
      invoiceDate: invoiceDate,
      dueDate: dueDate,
    );

    assignableInvoiceID ++;
    state = [...state, invoice];
  }
  void updateInvoice({
    String? id,
    required String customerName,
    required String customerId, 
    required double amount,
    required DateTime invoiceDate,
    required DateTime dueDate}){

      Invoice newInvoice = Invoice(
      id: id,
      customerId: customerId,
      customerName: customerName,
      amount: amount,
      invoiceDate: invoiceDate,
      dueDate: dueDate,
    );
    for (var x in state){
      if (x.id == newInvoice.id){
        state[state.indexOf(x)] = newInvoice;
      }
    }
    var temp = state;
    state = [];
    state = temp;
  }

  void updateInvoiceStatus(String id, String status){
    var temp = state.firstWhere((e) => e.id == id);
    temp.status = status;

    state[state.indexOf(state.firstWhere((e) => e.id == id))] = temp;

    var reset = state;
    state = [];
    state = reset;
  }

  void deleteInvoice(String id){
    state = state.where((c) => c.id != id).toList();
  }

  Invoice getInvoiceById(String id){
    return state.firstWhere((c) => c.id == id);
  }

  List<Invoice> searchInvoicesByCustomer(String customerName) {
    return state
        .where((invoice) =>
            invoice.customerName.toLowerCase().contains(customerName.toLowerCase()))
        .toList();
  }
}

final invoiceNotifierProvider =
    NotifierProvider<InvoiceNotifier, List<Invoice>>(() => InvoiceNotifier());
