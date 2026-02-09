import 'package:flutter/material.dart';
import 'package:treasure_quest/features/treasure/ar_view_screen.dart';
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
                    child: const Icon(Icons.image_outlined, size: 64, color: Colors.grey),
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
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: PrimaryButton(
              text: 'OPEN AR VIEW',
              onPressed: () => Navigator.pushNamed(context, ARViewScreen.routeName,),
            ),
          ),
        ],
      ),
    );
  }
}


