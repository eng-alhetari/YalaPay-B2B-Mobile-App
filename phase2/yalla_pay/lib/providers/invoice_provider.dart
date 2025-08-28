import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yalla_pay/model/invoice.dart';
import 'package:yalla_pay/providers/repo_provider.dart';
import 'package:yalla_pay/repo/yalapay_repo.dart';

class InvoiceNotifier extends AsyncNotifier<List<Invoice>> {
  late final YalapayRepo _yalapayRepo;

  @override
  Future<List<Invoice>> build() async {
    _yalapayRepo = await ref.watch(repoProvider.future);
    final customerId = ref.watch(selectedCustomerIdProvider);
    _yalapayRepo?.observeInvoices(customerId!).listen((invoices) {
      state = AsyncData(invoices);
    });
    return []; // Initial empty state
  }

  void addInvoice(Invoice invoice) async {
    await _yalapayRepo.addInvoice(invoice);
  }

  void updateInvoice(Invoice invoice) async {
    await _yalapayRepo.updateInvoice(invoice);
  }

  void deleteInvoice(String id) async {
    try {
      await _yalapayRepo.deleteInvoice(id);
    } catch (e) {
      print(e);
    }
  }

  Future<Invoice?> getInvoiceById(String id) async {
    try {
      return await _yalapayRepo.getInvoiceById(id);
    } catch (_) {
      return null;
    }
  }

  Future<void> updateInvoiceStatus(String id, String status) async {
    try {
      await _yalapayRepo.updateInvoiceStatus(id, status);
    } catch (e) {
      print('Error updating invoice status: $e');
    }
  }

  Future<List<Invoice>> searchInvoicesByCustomer(String customerName) async {
    try {
      return await _yalapayRepo.searchInvoicesByCustomer(customerName);
    } catch (e) {
      print('Error searching invoices: $e');
      return [];
    }
  }
}

final invoiceNotifierProvider =
    AsyncNotifierProvider<InvoiceNotifier, List<Invoice>>(() => InvoiceNotifier());
