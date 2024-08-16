import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _contactNumber = '';
  String _address = '';
  String _name = '';

  String get contactNumber => _contactNumber;
  String get address => _address;
  String get name => _name;

  void setUserDetails(String contactNumber, String address, String name) {
    _contactNumber = contactNumber;
    _address = address;
    _name = name;
    notifyListeners();
  }
}
