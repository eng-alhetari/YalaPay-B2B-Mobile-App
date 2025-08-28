import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yalla_pay/model/customer.dart';
import 'package:yalla_pay/providers/repo_provider.dart';
import 'package:yalla_pay/repo/yalapay_repo.dart';

class CustomerNotifier extends AsyncNotifier<List<Customer>> {
  late final YalapayRepo _YalapayRepo;

  @override
  Future<List<Customer>> build() async {
    _YalapayRepo = await ref.watch(repoProvider.future);
    _YalapayRepo.observeCustomers().listen((customers) {
      state = AsyncData(customers);
    });
    return []; // Initial empty state
  }

  void addCustomer(Customer customer) async {
    await _YalapayRepo.addCustomer(customer);
  }

  void updateCustomer(Customer customer) async {
    await _YalapayRepo.updateCustomer(customer);
  }

  void deleteCustomer(Customer customer) async {
    try {
      await _YalapayRepo.deleteCustomer(customer.id);
    } catch (e) {
      print(e);
    }
  }

  Future<Customer?> getCustomerById(String id) async {
    try {
      return await _YalapayRepo.getCustomerById(id);
    } catch (error) {
      return null;
    }
  }

  Future<List<Customer>> searchByCompanyName(String companyName) async {
    try {
      return await _YalapayRepo.searchByCompanyName(companyName);
    } catch (e) {
      print('Error searching customers: $e');
      return [];
    }
  }

  Future<List<Customer>> filterByCountry(String country) async {
    try {
      return await _YalapayRepo.filterByCountry(country);
    } catch (e) {
      print('Error filtering customers: $e');
      return [];
    }
  }
}

final customerNotifierProvider =
    AsyncNotifierProvider<CustomerNotifier, List<Customer>>(
        () => CustomerNotifier());
