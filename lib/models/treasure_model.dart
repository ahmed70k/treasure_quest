class TreasureModel {
  final String id;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final int rewardPoints;
  final String difficulty;

  TreasureModel({
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.rewardPoints,
    required this.difficulty,
  });

  static List<TreasureModel> get dummyList => [
        TreasureModel(
          id: '1',
          title: 'Golden Goblet',
          description: 'An ancient artifact hidden in the city park.',
          latitude: 30.0444,
          longitude: 31.2357,
          rewardPoints: 500,
          difficulty: 'Easy',
        ),
        TreasureModel(
          id: '2',
          title: 'Silver Dagger',
          description: 'Found near the old library ruins.',
          latitude: 30.0450,
          longitude: 31.2360,
          rewardPoints: 750,
          difficulty: 'Medium',
        ),
      ];
}
