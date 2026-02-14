import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:treasure_quest/features/home/show_treasure_list.dart';
import 'package:treasure_quest/features/profile/profile_screen.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import '../../common/constants/app_styles.dart';
import '../../providers/user_provider.dart';
import '../treasures/home_screen_logic.dart';

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
          // Map Background (Placeholder)
          Container(color: AppColors.surface),
          
          // Points Display (Always on top)
          Positioned(
            top: 16,
            left: 16,
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.stars, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text('${userProvider.user?.points ?? 0} PTS', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: Consumer<HomeScreenLogic>(
              builder: (context, logic, child) {
                final treasuresOffsets = logic.getTreasureOffsets(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                );

                return Stack(
                  children: [
                    // Treasures on the ground
                    ...treasuresOffsets.entries.map((entry) {
                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 100),
                        left: entry.value.dx,
                        top: entry.value.dy,
                        child: Column(
                          children: [
                            const Icon(Icons.auto_awesome, color: Colors.amber, size: 24),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.amber.withOpacity(0.5)),
                              ),
                              child: const Icon(Icons.card_giftcard, color: Colors.amber, size: 30), // Treasure Chest
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    // Moving Hero with Smooth Animation
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 100), // Very short for responsive feel
                      left: (MediaQuery.of(context).size.width / 2 - 150) + logic.virtualX + logic.gpsX,
                      top: (MediaQuery.of(context).size.height / 2 - 200) + logic.virtualY + logic.gpsY,
                      child: Column(
                        children: [
                          Transform.rotate(
                            angle: logic.rotationAngle * (3.14159 / 180),
                            child: SizedBox(
                              height: 300,
                              width: 300,
                              child: ModelViewer(
                                backgroundColor: Colors.transparent,
                                src: 'assets/models/mario.glb',
                                alt: 'Our Hero',
                                autoRotate: false,
                                autoPlay: true,
                                animationName: logic.isMoving ? 'walk' : 'idle',
                                cameraControls: false,
                                disableZoom: true,
                              ),
                            ),
                          ),
                          // Subtle Shadow under Mario
                          Container(
                            width: 60,
                            height: 10,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Premium Info Text
                    Positioned(
                      top: 100,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Column(
                            children: [
                              const Text('TREASURE HUNTER MODE', 
                                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2)),
                              const SizedBox(height: 4),
                              const Text('Use Joystick to navigate the map', style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // The Joystick
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: Joystick(
                          mode: JoystickMode.all,
                          listener: (details) {
                            logic.updateJoystick(details.x, details.y);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
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
        return const ShowTreasureList();
      },
    );
  }
}
