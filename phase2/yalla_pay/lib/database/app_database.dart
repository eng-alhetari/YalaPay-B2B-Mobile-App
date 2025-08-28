import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:yalla_pay/database/cheque_return_reasons_dao.dart';
import 'package:yalla_pay/database/cheque_status_dao.dart';
import 'package:yalla_pay/database/deposit_status_dao.dart';
import 'package:yalla_pay/database/invoice_status_dao.dart';
import 'package:yalla_pay/database/payment_modes_dao.dart';

import 'package:yalla_pay/model/bank_account.dart';
import 'package:yalla_pay/model/cheque_return_reasons.dart';
import 'package:yalla_pay/model/cheque_status.dart';
import 'package:yalla_pay/model/deposit_status.dart';
import 'package:yalla_pay/model/invoice.dart';
import 'package:yalla_pay/model/invoice_status.dart';
import 'package:yalla_pay/model/payment.dart';
import 'package:yalla_pay/model/payment_modes.dart';
import 'package:yalla_pay/model/user.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [PaymentModes, ChequeReturnReasons, ChequeStatus, DepositStatus, InvoiceStatus])
abstract class AppDatabase extends FloorDatabase{
  PaymentModesDao get paymentModesDao;
  ChequeReturnReasonsDao get chequeReturnReasonsDao;
  ChequeStatusDao get chequeStatusDao;
  DepositStatusDao get depositStatusDao;
  InvoiceStatusDao get invoiceStatusDao;

}