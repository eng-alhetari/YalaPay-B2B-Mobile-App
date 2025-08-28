import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yalla_pay/model/payment.dart';
import 'package:yalla_pay/providers/repo_provider.dart';
import 'package:yalla_pay/repo/yalapay_repo.dart';

class PaymentNotifier extends AsyncNotifier<List<Payment>> {
  late final YalapayRepo _yalapayRepo;

  @override
  Future<List<Payment>> build() async {
    _yalapayRepo = await ref.watch(repoProvider.future);
    final invoiceId = ref.watch(selectedInvoiceIdProvider);
    _yalapayRepo?.observePayments(invoiceId!).listen((payments) {
      state = AsyncData(payments);
    });
    return []; // Initial empty state
  }

  void addPayment(Payment payment) async {
    await _yalapayRepo.addPayment(payment);
  }

  void deletePayment(String id) async {
    try {
      await _yalapayRepo.deletePayment(id);
    } catch (e) {
      print(e);
    }
  }

  void updatePayment(Payment payment) async {
    await _yalapayRepo.updatePayment(payment);
  }

  Future<List<Payment>> searchPaymentsByInvoice(String invoiceNo) async {
    try {
      return await _yalapayRepo.searchPaymentsByInvoice(invoiceNo);
    } catch (e) {
      print('Error searching payments: $e');
      return [];
    }
  }

  Future<List<Payment>> searchPaymentsByModeAndID(String invoiceNo, String query) async {
    try {
      return await _yalapayRepo.searchPaymentsByModeAndID(invoiceNo, query);
    } catch (e) {
      print('Error searching payments: $e');
      return [];
    }
  }
  
}

final paymentNotifierProvider =
    AsyncNotifierProvider<PaymentNotifier, List<Payment>>(() => PaymentNotifier());
