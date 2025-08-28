import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yalla_pay/model/user.dart';

class UserNotifier extends Notifier<List<User>> {
  @override
  List<User> build() {
    initializeUsers();
    return [];
  }

  void initializeUsers() async {
    String data = await rootBundle.loadString('assets/data/users.json');
    var usersMap = jsonDecode(data);
    List<User> users = [];
    usersMap.forEach((map) => users.add(User.fromJson(map)));
    state = users;
  }

  void addUser(User user) {
      state = [...state, user];
  }
}

final userNotifierProvider =
    NotifierProvider<UserNotifier, List<User>>(() => UserNotifier());