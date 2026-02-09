import 'package:flutter/material.dart';

import '../../common/constants/app_styles.dart';
import '../../common/widgets/custom_widgets.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Join the Quest', style: AppTextStyles.h1),
            const SizedBox(height: 8),
            const Text('Create an account to start hunting', style: AppTextStyles.body),
            const SizedBox(height: 48),
            const CustomTextField(label: 'Full Name', icon: Icons.person_outline),
            const SizedBox(height: 16),
            const CustomTextField(label: 'Email', icon: Icons.email_outlined),
            const SizedBox(height: 16),
            const CustomTextField(label: 'Password', icon: Icons.lock_outline, isPassword: true),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'SIGN UP',
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
          ],
        ),
      ),
    );
  }
}