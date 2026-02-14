import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../features/treasures/treasure_service.dart';

class UserProvider extends  ChangeNotifier {
  UserModel? _user;
  StreamSubscription? _userSubscription;
  final TreasureService _treasureService = TreasureService();

  UserModel? get user => _user;
  
  String? get userEmail => _user?.email;
  String? get userId => _user?.id;

  void listenToUser(String uid) {
    _userSubscription?.cancel();
    _userSubscription = _treasureService.getUserData(uid).listen((userData) {
      _user = userData;
      notifyListeners();
    });
  }

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _userSubscription?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  bool get isAuthenticated => _user != null;
}
