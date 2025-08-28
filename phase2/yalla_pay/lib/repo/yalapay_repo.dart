import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yalla_pay/model/cheque.dart';
import 'package:yalla_pay/model/cheque_deposit.dart';
import 'package:yalla_pay/model/customer.dart';
import 'package:yalla_pay/model/invoice.dart';
import 'package:yalla_pay/model/payment.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:yalla_pay/model/user.dart';

class YalapayRepo {
  final CollectionReference customerRef;
  final CollectionReference chequeDepositRef;
  final CollectionReference invoiceRef;
  final CollectionReference paymentRef;
  final CollectionReference chequeRef;
  final CollectionReference bankTransferRef;
  final CollectionReference creditRef;
  final CollectionReference userRef;

  YalapayRepo ({
    required this.customerRef,
    required this.chequeDepositRef,
    required this.invoiceRef,
    required this.paymentRef,
    required this.chequeRef,
    required this.bankTransferRef,
    required this.creditRef,
    required this.userRef
  });

  Future<void> _initializeCollection(CollectionReference collection, String jsonPath) async {
    final snapshot = await collection.get();
    if (snapshot.docs.isEmpty) {
      final jsonData = await rootBundle.loadString(jsonPath);
      final List<dynamic> dataList = json.decode(jsonData);
      for (var data in dataList) {
        await collection.add(data);
      }
    }
  }

  Future<void> initializeDatabase() async {
    await _initializeCollection(customerRef, 'assets/data/customers.json');
    await _initializeCollection(invoiceRef, 'assets/data/invoices.json');
    await _initializeCollection(paymentRef, 'assets/data/payments.json');
    await _initializeCollection(chequeRef, 'assets/data/cheques.json');
    await _initializeCollection(chequeDepositRef, 'assets/data/cheque-deposits.json');
    // await _initializeCollection(bankTransferRef, 'assets/data/bank_transfers.json');
    // await _initializeCollection(creditRef, 'assets/data/credits.json');
    await _initializeCollection(userRef, 'assets/data/users.json');
  }
  //implement the firebase repo methods here

  // customers
  Stream<List<Customer>> observeCustomers() =>
      customerRef.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => Customer.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

  Future<void> addCustomer(Customer customer) async {
    await customerRef.add(customer.toMap());
  }

  Future<Customer?> getCustomerById(String id) async {
    final snapshot = await customerRef.doc(id).get();
    if (snapshot.exists) {
      return Customer.fromJson(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateCustomer(Customer customer) =>
      customerRef.doc(customer.id).update(customer.toMap());

  Future<void> deleteCustomer(String id) async {
    await invoiceRef
        .where('customerId', isEqualTo: id)
        .get()
        .then((snapshot) => snapshot.docs.forEach((doc) {
              invoiceRef.doc(doc.id).delete();
            }));
    await customerRef.doc(id).delete();
  }
  
  Future<List<Customer>> searchByCompanyName(String companyName) async {
    final querySnapshot = await customerRef
        .where('companyName', isEqualTo: companyName)
        .get();
    return querySnapshot.docs
        .map((doc) => Customer.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Customer>> filterByCountry(String country) async {
    final querySnapshot = await customerRef
        .where('address.country', isEqualTo: country)
        .get();
    return querySnapshot.docs
        .map((doc) => Customer.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // invoices
  Stream<List<Invoice>> observeInvoices(String customerId) => invoiceRef
      .where('customerId', isEqualTo: customerId)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Invoice.fromJson(doc.data() as Map<String, dynamic>))
          .toList());
  
  Future<void> addInvoice(Invoice invoice) async {
    await invoiceRef.add(invoice.toMap());
  }

  Future<void> updateInvoice(Invoice invoice) =>
      invoiceRef.doc(invoice.id).update(invoice.toMap());

  Future<void> deleteInvoice(String id) async {
    await paymentRef
        .where('invoiceNo', isEqualTo: id)
        .get()
        .then((snapshot) => snapshot.docs.forEach((doc) {
              paymentRef.doc(doc.id).delete();
            }));
    await invoiceRef.doc(id).delete();
  }

  Future<void> updateInvoiceStatus(String id, String status) =>
      invoiceRef.doc(id).update({'status': status});

  Future<Invoice?> getInvoiceById(String id) async {
    final snapshot = await invoiceRef.doc(id).get();
    if (snapshot.exists) {
      return Invoice.fromJson(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<Invoice>> searchInvoicesByCustomer(String customerName) async {
    final querySnapshot = await invoiceRef
        .where('customerName', isEqualTo: customerName)
        .get();
    return querySnapshot.docs
        .map((doc) => Invoice.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // payments
    Stream<List<Payment>> observePayments(String invoiceNo) => paymentRef
      .where('invoiceNo', isEqualTo: invoiceNo)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Payment.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

  Future<void> addPayment(Payment payment) async {
    await paymentRef.add(payment.toMap());
  }

  Future<void> deletePayment(String id) async {
    await paymentRef.doc(id).delete();
  }
  
  Future<void> updatePayment(Payment payment) async {
    await paymentRef.doc(payment.id).update(payment.toMap());
  }

  Future<List<Payment>> searchPaymentsByInvoice(String invoiceNo) async {
    final querySnapshot = await paymentRef.where('invoiceNo', isEqualTo: invoiceNo).get();
    return querySnapshot.docs
        .map((doc) => Payment.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Payment>> searchPaymentsByModeAndID(String invoiceNo, String query) async {
    final allPayments = await searchPaymentsByInvoice(invoiceNo);
    return allPayments.where((payment) {
      return payment.paymentMode.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // cheques
  Stream<List<Cheque>> observeCheques() =>
      chequeRef.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => Cheque.fromJson(doc.data() as Map<String, dynamic>))
          .toList());
          
  Future<void> addCheque(Cheque cheque) async {
    await chequeRef.add(cheque.toMap());
  }

  Future<void> deleteCheque(int chequeNo) async {
    final querySnapshot = await chequeRef.where('chequeNo', isEqualTo: chequeNo).get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> updateChequeStatus(int chequeNo, String status) async {
    final querySnapshot = await chequeRef.where('chequeNo', isEqualTo: chequeNo).get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'status': status});
    }
  }

  Future<void> updateChequeReturnReason(int chequeNo, String reason) async {
    final querySnapshot = await chequeRef.where('chequeNo', isEqualTo: chequeNo).get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'returnReason': reason});
    }
  }

  Future<void> updateChequeCashedDate(int chequeNo, DateTime date) async {
    final querySnapshot = await chequeRef.where('chequeNo', isEqualTo: chequeNo).get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'cashedDate': date.toIso8601String()});
    }
  }

  Future<void> updateChequeDetails(Cheque cheque) async {
    final querySnapshot = await chequeRef.where('chequeNo', isEqualTo: cheque.chequeNo).get();
    for (var doc in querySnapshot.docs) {
      await doc.reference.update(cheque.toMap());
    }
  }

  Future<List<Cheque>> searchChequesByBank(String bankName) async {
    final querySnapshot = await chequeRef.where('bankName', isEqualTo: bankName).get();
    return querySnapshot.docs
        .map((doc) => Cheque.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<Cheque>> filterChequesByStatus(String status) async {
    final querySnapshot = await chequeRef.where('status', isEqualTo: status).get();
    return querySnapshot.docs
        .map((doc) => Cheque.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // cheque-deposits
  Stream<List<ChequeDeposit>> observeChequeDeposits() =>
      chequeDepositRef.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => ChequeDeposit.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

  Future<void> addDeposit(ChequeDeposit deposit) async {
    await chequeDepositRef.add(deposit.toMap());
  }

  Future<void> deleteDeposit(String id) async {
    await chequeDepositRef.doc(id).delete();
  }

  Future<void> updateDepositStatus(String id, String status) async {
    await chequeDepositRef.doc(id).update({'status': status});
  }

  Future<void> updateDepositCashedDate(String id, DateTime date) async {
    await chequeDepositRef.doc(id).update({'cashedDate': date.toIso8601String()});
  }

  Future<List<ChequeDeposit>> searchDepositsByAccount(String accountNo) async {
    final querySnapshot = await chequeDepositRef
        .where('bankAccountNo', isEqualTo: accountNo)
        .get();
    return querySnapshot.docs
        .map((doc) => ChequeDeposit.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<ChequeDeposit>> filterDepositsByStatus(String status) async {
    final querySnapshot = await chequeDepositRef
        .where('status', isEqualTo: status)
        .get();
    return querySnapshot.docs
        .map((doc) => ChequeDeposit.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // users
  Stream<List<User>> observeUerss() =>
      userRef.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
          .toList());

  Future<void> addUser(User user) async {
    await userRef.add(user.toMap());
  }

  Future<User?> getUserById(String id) async {
    final snapshot = await userRef.doc(id).get();
    if (snapshot.exists) {
      return User.fromJson(snapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(User user) =>
      userRef.doc(user.id).update(user.toMap());

  Future<void> deleteUser(String id) async {
    await userRef.doc(id).delete();
  }
 

  

  







}
