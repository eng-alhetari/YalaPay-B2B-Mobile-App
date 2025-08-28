import 'dart:core';

import 'package:floor/floor.dart';
import 'package:yalla_pay/model/cheque_status.dart';

@dao
abstract class ChequeStatusDao {
  @insert
  Future<void> addChequeStatus(ChequeStatus chequeStatus);

  @delete
  Future<void> deleteChequeStatus(ChequeStatus chequeStatus);

  @Query('SELECT * FROM chequeStatus')
  Stream<List<ChequeStatus>> observeChequeStatus();
}