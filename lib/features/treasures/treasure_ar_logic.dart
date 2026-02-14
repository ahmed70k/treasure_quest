import 'package:flutter/material.dart';
import '../../models/treasure_model.dart';
import 'treasure_service.dart';

class TreasureARLogic extends ChangeNotifier {
  final TreasureService _treasureService = TreasureService();
  
  bool _isCollecting = false;
  bool get isCollecting => _isCollecting;

  Future<bool> collectTreasure(BuildContext context, TreasureModel treasure, String uid) async {
    if (_isCollecting) return false;
    
    _isCollecting = true;
    notifyListeners();

    try {
      await _treasureService.collectTreasure(uid, treasure);
      _isCollecting = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error collecting treasure: $e');
      _isCollecting = false;
      notifyListeners();
      return false;
    }
  }
}
