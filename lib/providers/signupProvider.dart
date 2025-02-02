import 'package:flutter/material.dart';
import "package:provider/provider.dart";

class SignupProvider with ChangeNotifier {
  Map<String, dynamic> userMap = {};

  void setUser(Map<String, dynamic> userData) async {
    this.userMap = userData;
    notifyListeners();
  }
}
