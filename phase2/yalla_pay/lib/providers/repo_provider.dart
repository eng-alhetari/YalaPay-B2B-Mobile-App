import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yalla_pay/repo/yalapay_repo.dart';

final repoProvider = FutureProvider((ref) async {

  final db = FirebaseFirestore.instance;
  final customerRef = db.collection('customers');
  final chequeDepositRef = db.collection('chequeDeposits');
  //treat the payments like document instances of 'payments' collection - 
  //- that is part of a payment document of an invoice. remember:
  //collection > document > collection > document
  //invoices > invoice document > payments collection of invoice document > cheques, bank transfers, credit 
  final invoiceRef = db.collection('invoices');
  final paymentRef = db.collection('payments');
  final chequeRef = db.collection('cheques');
  final bankTransferRef = db.collection('bankTransfers');
  final creditRef = db.collection('credits');

  final userRef = db.collection('users');

  final repo = YalapayRepo(
    customerRef: customerRef, 
    chequeDepositRef: chequeDepositRef, 
    invoiceRef: invoiceRef, 
    paymentRef: paymentRef, 
    chequeRef: chequeRef, 
    bankTransferRef: bankTransferRef, 
    creditRef: creditRef, 
    userRef: userRef
  );
  // Initialize Firestore database
  await repo.initializeDatabase();

  return repo;
});

final selectedCustomerIdProvider = StateProvider<String?>((ref) => null);
final selectedInvoiceIdProvider = StateProvider<String?>((ref) => null);



// how do you assign a value to the selectedCustomerIdProvider?

// you do it by calling the .state property of the provider and assigning a value to it
// selectedCustomerIdProvider.state = "THE ID OF THE CUSTOMER YOU WANT TO SELECT";