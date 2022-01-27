import 'package:flutter/material.dart';

class NotificatioProvider with ChangeNotifier {
  bool notificationVisible = false;

  void alterVisibility() {
    notificationVisible = !notificationVisible;
    notifyListeners();
  }
}
