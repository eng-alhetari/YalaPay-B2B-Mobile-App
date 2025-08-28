import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yalla_pay/model/cheque.dart';
import 'package:yalla_pay/providers/repo_provider.dart';
import 'package:yalla_pay/repo/yalapay_repo.dart';

class ChequeNotifier extends AsyncNotifier<List<Cheque>> {
  late final YalapayRepo _yalapayRepo;

  @override
  Future<List<Cheque>> build() async {
    _yalapayRepo = await ref.watch(repoProvider.future);
    _yalapayRepo?.observeCheques().listen((cheques) {
      state = AsyncData(cheques);
    });
    return []; // Initial empty state
  }

  Future<void> addCheque(Cheque cheque) async {
    try {
      await _yalapayRepo.addCheque(cheque);
    } catch (e) {
      print('Error adding cheque: $e');
    }
  }

  Future<void> deleteCheque(int chequeNo) async {
    try {
      await _yalapayRepo.deleteCheque(chequeNo);
    } catch (e) {
      print('Error deleting cheque: $e');
    }
  }

  Future<void> updateChequeDetails(Cheque cheque) async {
    try {
      await _yalapayRepo.updateChequeDetails(cheque);
    } catch (e) {
      print('Error updating cheque details: $e');
    }
  }

  Future<void> updateChequeStatus(int chequeNo, String status) async {
    try {
      await _yalapayRepo.updateChequeStatus(chequeNo, status);
    } catch (e) {
      print('Error updating cheque status: $e');
      rethrow;
    }
  }

  Future<void> updateChequeReturnReason(int chequeNo, String reason) async {
    try {
      await _yalapayRepo.updateChequeReturnReason(chequeNo, reason);
    } catch (e) {
      print('Error updating cheque return reason: $e');
      rethrow;
    }
  }

  Future<void> updateChequeCashedDate(int chequeNo, DateTime date) async {
    try {
      await _yalapayRepo.updateChequeCashedDate(chequeNo, date);
    } catch (e) {
      print('Error updating cheque cashed date: $e');
      rethrow;
    }
  }

  Future<List<Cheque>> searchChequesByBank(String bankName) async {
    try {
      return await _yalapayRepo.searchChequesByBank(bankName);
    } catch (e) {
      print('Error searching cheques by bank: $e');
      return [];
    }
  }

  Future<List<Cheque>> filterChequesByStatus(String status) async {
    try {
      return await _yalapayRepo.filterChequesByStatus(status);
    } catch (e) {
      print('Error filtering cheques by status: $e');
      return [];
    }
  }

}

final chequeNotifierProvider =
    AsyncNotifierProvider<ChequeNotifier, List<Cheque>>(() => ChequeNotifier());
