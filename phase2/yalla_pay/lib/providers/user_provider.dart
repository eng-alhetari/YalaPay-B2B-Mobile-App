import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yalla_pay/model/user.dart';
import 'package:yalla_pay/providers/repo_provider.dart';
import 'package:yalla_pay/repo/yalapay_repo.dart';

class UserNotifier extends AsyncNotifier<List<User>> {
  late final YalapayRepo _YalapayRepo;

  @override
  Future<List<User>> build() async {
    _YalapayRepo = await ref.watch(repoProvider.future);
    _YalapayRepo.observeUerss().listen((users) {
      state = AsyncData(users);
    });
    return []; // Initial empty state
  }

  void addUser(User user) async {
    await _YalapayRepo.addUser(user);
  }

  void updateUser(User user) async {
    await _YalapayRepo.updateUser(user);
  }

  void deleteUser(String id) async {
    try {
      await _YalapayRepo.deleteUser(id);
    } catch (e) {
      print(e);
    }
  }

  Future<User?> getUserById(String id) async {
    try {
      return await _YalapayRepo.getUserById(id);
    } catch (error) {
      return null;
    }
  }



}

final userNotifierProvider =
    AsyncNotifierProvider<UserNotifier, List<User>>(() => UserNotifier());