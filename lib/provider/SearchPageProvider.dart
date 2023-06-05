import 'package:flutter/material.dart';

class SearchPageProvider with ChangeNotifier {
  String value = "";
  void setValue(String value) {
    this.value = value;
    notifyListeners();
  }
}
