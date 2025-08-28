import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yalla_pay/model/cheque_deposit.dart';
import 'package:yalla_pay/providers/repo_provider.dart';
import 'package:yalla_pay/repo/yalapay_repo.dart';

class ChequeDepositNotifier extends AsyncNotifier<List<ChequeDeposit>> {
  late final YalapayRepo _yalapayRepo;

  @override
  Future<List<ChequeDeposit>> build() async {
    _yalapayRepo = await ref.watch(repoProvider.future);
    _yalapayRepo?.observeChequeDeposits().listen((deposits) {
      state = AsyncData(deposits);
    });
    return []; // Initial empty state
  }

  void addDeposit(ChequeDeposit deposit) async {
    await _yalapayRepo.addDeposit(deposit);
  }

  void deleteDeposit(String id) async {
    try {
      await _yalapayRepo.deleteDeposit(id);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateDepositStatus(String id, String status) async {
    try {
      await _yalapayRepo.updateDepositStatus(id, status);
    } catch (e) {
      print('Error updating deposit status: $e');
    }
  }

  Future<void> updateDepositCashedDate(String id, DateTime date) async {
    try {
      await _yalapayRepo.updateDepositCashedDate(id, date);
    } catch (e) {
      print('Error updating deposit cashed date: $e');
    }
  }

  Future<List<ChequeDeposit>> searchDepositsByAccount(String accountNo) async {
    try {
      return await _yalapayRepo.searchDepositsByAccount(accountNo);
    } catch (e) {
      print('Error searching deposits: $e');
      return [];
    }
  }

  Future<List<ChequeDeposit>> filterDepositsByStatus(String status) async {
    try {
      return await _yalapayRepo.filterDepositsByStatus(status);
    } catch (e) {
      print('Error filtering deposits: $e');
      return [];
    }
  }

}

final chequeDepositNotifierProvider =
    AsyncNotifierProvider<ChequeDepositNotifier, List<ChequeDeposit>>(() => ChequeDepositNotifier());
