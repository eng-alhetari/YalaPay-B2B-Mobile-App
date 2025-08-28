import 'dart:core';

import 'package:floor/floor.dart';
import 'package:yalla_pay/model/cheque_return_reasons.dart';

@dao
abstract class ChequeReturnReasonsDao {
  @insert
  Future<void> addChequeReturnReasons(ChequeReturnReasons chequeStatusReason);

  @delete
  Future<void> deleteChequeReturnReasons(ChequeReturnReasons chequeStatusReason);

  @Query('SELECT * FROM chequeReturnReasons')
  Stream<List<ChequeReturnReasons>> observeChequeReturnReasons();

}