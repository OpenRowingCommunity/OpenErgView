import 'package:c2bluetooth/c2bluetooth.dart';
import 'package:flutter/material.dart';

class ErgometerStore with ChangeNotifier {
  Ergometer? _erg;

  Ergometer? get erg => _erg;

  set erg(Ergometer? erg) {
    _erg = erg;
    notifyListeners();
  }
}
