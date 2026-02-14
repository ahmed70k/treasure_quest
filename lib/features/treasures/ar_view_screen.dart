import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:provider/provider.dart';
import 'package:treasure_quest/features/treasures/treasure_ar_logic.dart';
import 'package:treasure_quest/models/treasure_model.dart';
import '../../common/widgets/custom_widgets.dart';
import '../../providers/user_provider.dart';

class ARViewScreen extends StatelessWidget {
  static const routeName = '/ARViewScreen';
  const ARViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final treasure = ModalRoute.of(context)!.settings.arguments as TreasureModel;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Real-time AR View using ModelViewer
          // This uses Google's Scene Viewer on Android and Quick Look on iOS
          ModelViewer(
            backgroundColor: Colors.transparent,
            src: 'assets/models/mario.glb',
            alt: 'Our 3D Hero - Budget Mario',
            ar: true,
            arModes: const ['scene-viewer', 'webxr', 'quick-look'],
            autoRotate: true,
            cameraControls: true,
            autoPlay: true, // Start animation immediately
            arPlacement: ArPlacement.floor, // Place Mario on the ground
            disableZoom: false,
          ),
          Positioned(
            top: 48,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Center(
              child: Consumer<TreasureARLogic>(
                builder: (context, logic, child) {
                  return logic.isCollecting
                    ? const CircularProgressIndicator()
                    : PrimaryButton(
                        text: 'COLLECT TREASURE',
                        onPressed: () async {
                          final success = await logic.collectTreasure(
                            context,
                            treasure,
                            userProvider.user?.id ?? '',
                          );
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Treasure Collected! +${treasure.rewardPoints} PTS')),
                            );
                            Navigator.pop(context);
                          }
                        },
                      );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}