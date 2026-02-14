class TreasureModel {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final int rewardPoints;
  final String difficulty;
  final bool isActive;

  TreasureModel({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.rewardPoints,
    required this.difficulty,
    this.isActive = true,
  });

  factory TreasureModel.fromFireStore(String id, Map<String, dynamic> data) {
    return TreasureModel(
      id: id,
      title: data['title'] ?? 'Unknown Treasure',
      description: data['description'] ?? '',
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      rewardPoints: data['rewardPoints'] ?? 0,
      difficulty: data['difficulty'] ?? 'Easy',
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      'title': title,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'rewardPoints': rewardPoints,
      'difficulty': difficulty,
      'isActive': isActive,
    };
  }
}

