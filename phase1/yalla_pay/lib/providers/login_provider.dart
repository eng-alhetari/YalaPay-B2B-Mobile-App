import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginNotifier extends Notifier <bool>{
  @override
  bool build() {
    return false;
  }

  void login(){
    state = true;
  }

  void logout(){
    state = false;
  }
}

final loginNotifierProvider = NotifierProvider<LoginNotifier, bool>(() => LoginNotifier(),);