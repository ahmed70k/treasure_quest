import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final int points;
  final String? profileImageUrl;
  final DateTime createdAt;
  final List<String> treasures;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.points = 0,
    this.profileImageUrl,
    required this.createdAt,
    this.treasures = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': id,
      'username': name,
      'email': email,
      'points': points,
      'profileImageUrl': profileImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'treasures': treasures,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['uid'] ?? '',
      name: map['username'] ?? '',
      email: map['email'] ?? '',
      points: map['points'] ?? 0,
      profileImageUrl: map['profileImageUrl'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      treasures: List<String>.from(map['treasures'] ?? []),
    );
  }

  factory UserModel.dummy() {
    return UserModel(
      id: '1',
      name: 'Treasure Hunter',
      email: 'hunter@example.com',
      points: 1250,
      createdAt: DateTime.now(),
    );
  }
}
