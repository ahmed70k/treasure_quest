import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ar_view_screen.dart';
import 'home_screen_logic.dart';
import '../../common/constants/app_styles.dart';
import '../../common/widgets/custom_widgets.dart';
import '../../models/treasure_model.dart';

class TreasureScreen extends StatelessWidget {
  static const routeName = '/treasure';
  const TreasureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final treasure = ModalRoute.of(context)!.settings.arguments as TreasureModel;

    return Scaffold(
      appBar: AppBar(title: Text(treasure.title)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.primary),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Difficulty', style: AppTextStyles.caption),
                          Text(treasure.difficulty, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Reward', style: AppTextStyles.caption),
                          Text('${treasure.rewardPoints} PTS', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Description', style: AppTextStyles.h2),
                  const SizedBox(height: 8),
                  Text(treasure.description, style: AppTextStyles.body),
                  const SizedBox(height: 24),
                  Consumer<HomeScreenLogic>(
                    builder: (context, logic, child) {
                      final distance = logic.calculateDistance(treasure.latitude, treasure.longitude);
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Text(
                              distance.isInfinite 
                                ? 'Calculating distance...' 
                                : 'Distance: ${distance.toStringAsFixed(1)}m',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Consumer<HomeScreenLogic>(
              builder: (context, logic, child) {
                final isInRange = logic.isWithinRange(treasure.latitude, treasure.longitude);
                return PrimaryButton(
                  text: isInRange ? 'OPEN AR VIEW' : 'GET CLOSER (NEED <20m)',
                  onPressed: isInRange 
                    ? () => Navigator.pushNamed(
                        context, 
                        ARViewScreen.routeName, 
                        arguments: treasure,
                      )
                    : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
