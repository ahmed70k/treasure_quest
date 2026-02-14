import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FireStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- User Related Operations ---

  /// Create or update a user document in the "users" collection
  Future<void> saveUserData(UserModel user) async {
    try {
      await _db.collection('users').doc(user.id).set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw 'Failed to save user data: $e';
    }
  }

  /// Fetch user data by UID
  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw 'Failed to fetch user data: $e';
    }
  }

  /// Stream of user data for real-time updates
  Stream<UserModel?> userStream(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // --- Treasure / Progress Related Operations ---

  /// Add a treasure ID to the user's unlocked treasures list
  Future<void> unlockTreasure(String uid, String treasureId, int pointsEarned) async {
    try {
      await _db.collection('users').doc(uid).update({
        'treasures': FieldValue.arrayUnion([treasureId]),
        'points': FieldValue.increment(pointsEarned),
      });
    } catch (e) {
      throw 'Failed to unlock treasure: $e';
    }
  }

  /// Update any specific field for the user
  Future<void> updateUserField(String uid, String field, dynamic value) async {
    try {
      await _db.collection('users').doc(uid).update({field: value});
    } catch (e) {
      throw 'Failed to update user field ($field): $e';
    }
  }
}
