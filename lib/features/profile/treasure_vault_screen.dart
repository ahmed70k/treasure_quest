import 'package:flutter/material.dart';
import '../../common/constants/app_styles.dart';
import '../../models/treasure_model.dart';
import '../treasures/treasure_service.dart';

class TreasureVaultScreen extends StatelessWidget {
  static const routeName = '/treasure-vault';
  final List<String> treasureIds;

  const TreasureVaultScreen({super.key, required this.treasureIds});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Treasure Vault')),
      body: treasureIds.isEmpty
          ? const Center(child: Text('Your vault is empty! Start hunting.'))
          : StreamBuilder<List<TreasureModel>>(
              stream: TreasureService().getTreasuresByIds(treasureIds),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                
                final treasures = snapshot.data ?? [];
                
                if (treasures.isEmpty) {
                   return const Center(child: Text('Could not load treasure details.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: treasures.length,
                  itemBuilder: (context, index) {
                    final treasure = treasures[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.check, color: Colors.white),
                        ),
                        title: Text(treasure.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${treasure.rewardPoints} Points • ${treasure.difficulty}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
