import 'package:flutter/material.dart';
import '../../common/constants/app_styles.dart';

class LegalScreen extends StatelessWidget {
  final String title;
  final String content;

  const LegalScreen({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          content,
          style: const TextStyle(fontSize: 16, height: 1.5, color: AppColors.onBackground),
        ),
      ),
    );
  }
}

// Dummy Content
const String dummyPrivacyPolicy = """
Privacy Policy

1. Introduction
Welcome to Treasure Quest! We value your privacy and are committed to protecting your personal data. This policy explains how we collect, use, and share your information.

2. Data Collection
We collect the following information:
- User Profile: Username, email address, profile picture.
- Location Data: Your precise location is used to find nearby treasures and is essential for the core gameplay.
- Gameplay Data: Treasures collected, points earned, and game progress.

3. How We Use Data
- To provide and maintain the Service.
- To improve user experience and app performance.
- To personalize your gameplay and track achievements.

4. Data Sharing
We do not sell your personal data. We may share data with third-party service providers (e.g., Google Maps, Firebase) solely for the purpose of operating the app.

5. Your Rights
You can access, correct, or delete your personal data through the app settings or by contacting us.

6. Contact
If you have questions about this policy, please contact us at support@treasurequest.app.
""";

const String dummyTermsOfService = """
Terms of Service

1. Acceptance of Terms
By accessing or using Treasure Quest, you agree to be bound by these Terms. If you do not agree, please do not use the app.

2. User Conduct
You agree to use the app responsibly and safely. Do not trespass on private property or endanger yourself or others while playing.

3. Account Security
You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.

4. Intellectual Property
All content, features, and functionality of the app are owned by Treasure Quest and are protected by international copyright laws.

5. Termination
We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.

6. Disclaimer
The app is provided on an "AS IS" and "AS AVAILABLE" basis. We do not warrant that the app will be uninterrupted or error-free.

7. Changes to Terms
We reserve the right to modify these terms at any time.

Last updated: October 2023
""";
