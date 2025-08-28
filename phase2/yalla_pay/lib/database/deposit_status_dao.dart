import 'dart:core';

import 'package:floor/floor.dart';
import 'package:yalla_pay/model/deposit_status.dart';

@dao
abstract class DepositStatusDao {
@insert
  Future<void> addDepositStatus(DepositStatus depositStatus);

  @delete
  Future<void> deleteDepositStatus(DepositStatus depositStatus);

  @Query('SELECT * FROM depositStatus')
  Stream<List<DepositStatus>> observeDepositStatus();
}