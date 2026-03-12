import 'package:flutter/foundation.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool _busy = false;

  bool get isBusy => _busy;

  setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
