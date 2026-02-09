import 'package:flutter/material.dart';
import 'package:treasure_quest/features/auth/signup_screen.dart';
import 'package:treasure_quest/features/home/home_screen.dart';
import '../../common/constants/app_styles.dart';
import '../../common/widgets/custom_widgets.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome Back!', style: AppTextStyles.h1),
            const SizedBox(height: 8),
            const Text('Login to continue your quest', style: AppTextStyles.body),
            const SizedBox(height: 48),
            const CustomTextField(
              label: 'Email',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),
            const CustomTextField(
              label: 'Password',
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'LOGIN',
              onPressed: () => Navigator.pushReplacementNamed(context, HomeScreen.routeName),
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, SignupScreen.routeName),
                child: const Text('Don\'t have an account? Sign Up'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


