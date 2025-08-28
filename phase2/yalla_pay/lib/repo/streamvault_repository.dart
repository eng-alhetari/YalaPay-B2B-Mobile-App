import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:yalla_pay/database/cheque_return_reasons_dao.dart';
import 'package:yalla_pay/database/cheque_status_dao.dart';
import 'package:yalla_pay/database/deposit_status_dao.dart';
import 'package:yalla_pay/database/invoice_status_dao.dart';
import 'package:yalla_pay/database/payment_modes_dao.dart';
import 'package:yalla_pay/model/address.dart';
import 'package:yalla_pay/model/bank_account.dart';
import 'package:yalla_pay/model/cheque_return_reasons.dart';
import 'package:yalla_pay/model/cheque_status.dart';
import 'package:yalla_pay/model/deposit_status.dart';
import 'package:yalla_pay/model/invoice_status.dart';
import 'package:yalla_pay/model/payment_modes.dart';
import 'package:yalla_pay/model/user.dart';


class StreamVaultRepository implements ChequeReturnReasonsDao, ChequeStatusDao, DepositStatusDao, InvoiceStatusDao, PaymentModesDao{
  final PaymentModesDao paymentModesDao;
  final ChequeReturnReasonsDao  chequeReturnReasonsDao;
  final ChequeStatusDao chequeStatusDao;
  final DepositStatusDao depositStatusDao;
  final InvoiceStatusDao invoiceStatusDao;

  StreamVaultRepository({required this.paymentModesDao, required this.chequeReturnReasonsDao, required this.chequeStatusDao, required this.depositStatusDao, required this.invoiceStatusDao});


  void initializeDatabase() async {

    observeChequeReturnReasons().listen((data)async{
      if(data.isEmpty){
        String data = await rootBundle.loadString('assets/data/return-reasons.json');
        var chequeReturnReasonsMap = jsonDecode(data);
        for (var map in chequeReturnReasonsMap){
          addChequeReturnReasons(ChequeReturnReasons(reason: map.toString()));
        }
  }});

  observeChequeStatus().listen((data)async{
      if(data.isEmpty){
        String data = await rootBundle.loadString('assets/data/cheque-status.json');
        var chequeStatusMap = jsonDecode(data);
        for (var map in chequeStatusMap){
          addChequeStatus(ChequeStatus(status: map.toString()));
        }
  }});

  observeDepositStatus().listen((data)async{
      if(data.isEmpty){
        String data = await rootBundle.loadString('assets/data/deposit-status.json');
        var depositStatusMap = jsonDecode(data);
        for (var map in depositStatusMap){
          addDepositStatus(DepositStatus(status: map.toString()));
        }
  }});

  observeInvoiceStatus().listen((data)async{
      if(data.isEmpty){
        String data = await rootBundle.loadString('assets/data/invoice-status.json');
        var invoiceStatusMap = jsonDecode(data);
        for (var map in invoiceStatusMap){
          addInvoiceStatus(InvoiceStatus(status: map.toString()));
        }
  }});

  observePaymentModes().listen((data)async{
      if(data.isEmpty){
        String data = await rootBundle.loadString('assets/data/payment-modes.json');
        var paymentModesMap = jsonDecode(data);
        for (var map in paymentModesMap){
          addPaymentModes(PaymentModes(mode: map.toString()));
        }
  }});

}

//ChequeReturnReasons
  @override
  Future<void> addChequeReturnReasons(ChequeReturnReasons chequeStatusReason) => chequeReturnReasonsDao.addChequeReturnReasons(chequeStatusReason);
  
  @override
  Future<void> deleteChequeReturnReasons(ChequeReturnReasons chequeStatusReason) => chequeReturnReasonsDao.deleteChequeReturnReasons(chequeStatusReason);

  @override
  Stream<List<ChequeReturnReasons>> observeChequeReturnReasons() => chequeReturnReasonsDao.observeChequeReturnReasons();


//ChequeStatu
  @override
  Future<void> addChequeStatus(ChequeStatus chequeStatus) => chequeStatusDao.addChequeStatus(chequeStatus);

  @override
  Future<void> deleteChequeStatus(ChequeStatus chequeStatus) => chequeStatusDao.deleteChequeStatus(chequeStatus);
  
  @override
  Stream<List<ChequeStatus>> observeChequeStatus() => chequeStatusDao.observeChequeStatus();


//DepositStatus
  @override
  Future<void> addDepositStatus(DepositStatus depositStatus) => depositStatusDao.addDepositStatus(depositStatus);
  
  @override
  Future<void> deleteDepositStatus(DepositStatus depositStatus) => depositStatusDao.deleteDepositStatus(depositStatus);
  
  @override
  Stream<List<DepositStatus>> observeDepositStatus() => depositStatusDao.observeDepositStatus();


//InvoiceStatus
  @override
  Future<void> addInvoiceStatus(InvoiceStatus invoiceStatus) => invoiceStatusDao.addInvoiceStatus(invoiceStatus);
  
  @override
  Future<void> deleteInvoiceStatus(InvoiceStatus invoiceStatus) => invoiceStatusDao.deleteInvoiceStatus(invoiceStatus);
  
  @override
  Stream<List<InvoiceStatus>> observeInvoiceStatus() => invoiceStatusDao.observeInvoiceStatus();


//PaymentModes
  @override
  Future<void> addPaymentModes(PaymentModes paymentModes) => paymentModesDao.addPaymentModes(paymentModes);

  @override
  Future<void> deletePaymentModes(PaymentModes paymentModes) => paymentModesDao.deletePaymentModes(paymentModes);

  @override
  Stream<List<PaymentModes>> observePaymentModes() => paymentModesDao.observePaymentModes();

}
