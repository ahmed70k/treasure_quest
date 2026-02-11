import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  
  // The email is the primary identifier requested by the user
  String? get userEmail => _user?.email;
  String? get userId => _user?.id;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  bool get isAuthenticated => _user != null;
}
