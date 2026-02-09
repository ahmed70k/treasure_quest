import 'package:flutter/material.dart';
import 'package:treasure_quest/features/home/show_treasure_list.dart';
import 'package:treasure_quest/features/profile/profile_screen.dart';
import '../../common/constants/app_styles.dart';
import '../../models/treasure_model.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Treasures'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: AppColors.primary,
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.black),
                onPressed: () => Navigator.pushNamed(context, ProfileScreen.routeName),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Google Map Placeholder
          Container(
            color: AppColors.surface,
            width: double.infinity,
            height: double.infinity,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Google Map Placeholder', style: AppTextStyles.caption),
                ],
              ),
            ),
          ),
          // Points Display
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.5)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.stars, color: AppColors.primary, size: 20),
                  SizedBox(width: 8),
                  Text('1,250 PTS', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTreasureList(context),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.list, color: Colors.black),
        label: const Text('List View', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showTreasureList(BuildContext context) {

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ShowTreasureList();
      },
    );
  }
}
