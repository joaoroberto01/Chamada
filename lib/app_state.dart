import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  String? userId;

  void setUserId(String id) {
    userId = id;
    notifyListeners();
  }
}
