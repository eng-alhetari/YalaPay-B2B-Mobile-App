import 'dart:core';

import 'package:floor/floor.dart';
import 'package:yalla_pay/model/payment_modes.dart';

@dao
abstract class PaymentModesDao {
@insert
  Future<void> addPaymentModes(PaymentModes paymentModes);

  @delete
  Future<void> deletePaymentModes(PaymentModes paymentModes);

  @Query('SELECT * FROM paymentModes')
  Stream<List<PaymentModes>> observePaymentModes();
}