import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateNotifier extends Notifier<bool>{
  @override
  bool build() {
    initialize();
    return false;
  }

  void initialize(){
    state = false;
  }

  void startUpdate(){
    state = true;
    
    Future.delayed(const Duration(milliseconds: 500), (){
      state = false;
    });
  }
}

final updateNotifierProvider = NotifierProvider<UpdateNotifier, bool>(() => UpdateNotifier(),);