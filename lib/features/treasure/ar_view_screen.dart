import 'package:flutter/material.dart';

import '../../common/widgets/custom_widgets.dart';

class ARViewScreen extends StatelessWidget {
  static const routeName = '/ARViewScreen';
  const ARViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // AR Camera Placeholder
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt_outlined, size: 80, color: Colors.white54),
                SizedBox(height: 16),
                Text('AR Camera View Placeholder', style: TextStyle(color: Colors.white54)),
              ],
            ),
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
              child: PrimaryButton(
                text: 'COLLECT TREASURE',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Treasure Collected! +500 PTS')),
                  );
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}