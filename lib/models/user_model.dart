class UserModel {
  final String id;
  final String name;
  final String email;
  final int points;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.points = 0,
    this.profileImageUrl,
  });

  factory UserModel.dummy() {
    return UserModel(
      id: '1',
      name: 'Treasure Hunter',
      email: 'hunter@example.com',
      points: 1250,
    );
  }
}
