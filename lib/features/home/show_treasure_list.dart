import 'package:flutter/material.dart';
import 'package:treasure_quest/features/treasure/treasure_screens.dart';

import '../../common/constants/app_styles.dart';
import '../../models/treasure_model.dart';

class ShowTreasureList extends StatelessWidget {
  const ShowTreasureList({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('Available Treasures', style: AppTextStyles.h2),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: TreasureModel.dummyList.length,
              itemBuilder: (context, index) {
                final treasure = TreasureModel.dummyList[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    treasure.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(treasure.difficulty),
                  trailing: Text(
                    '${treasure.rewardPoints} PTS',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      TreasureScreen.routeName,
                      arguments: treasure,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
