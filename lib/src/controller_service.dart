import 'package:flutter/material.dart';

class ControllerService with ChangeNotifier {
  // Flags
  int _flashMode = 0;

  int get flashMode => _flashMode;

  void changeFlashMode() {
    if (_flashMode == 0) {
      _flashMode = 1;
      notifyListeners();
    } else {
      _flashMode = 0;
      notifyListeners();
    }
  }
}
