import 'package:flutter/material.dart';
import 'package:treasure_quest/features/auth/login_screen.dart';
import 'package:treasure_quest/features/home/home_screen.dart';
import 'package:provider/provider.dart';
import '../../common/constants/app_styles.dart';
import '../../common/widgets/custom_widgets.dart';
import 'auth_service.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_isLoading) return; 
    
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

      try {
        // Call modified signUpWithEmail which now creates Firestore user document
        UserModel? user = await _authService.signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
          username: _nameController.text.trim(),
        );
        if (user != null && mounted) {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(user);
          userProvider.listenToUser(user.id);
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }
      } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Join the Quest', style: AppTextStyles.h1),
              const SizedBox(height: 8),
              const Text('Create an account to start hunting', style: AppTextStyles.body),
              const SizedBox(height: 48),
              CustomTextField(
                label: 'Full Name', 
                icon: Icons.person_outline,
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your name';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Email', 
                icon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Email is required';
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Password', 
                icon: Icons.lock_outline, 
                isPassword: true,
                controller: _passwordController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Password is required';
                  if (value.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Confirm Password', 
                icon: Icons.lock_outline, 
                isPassword: true,
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please confirm your password';
                  if (value != _passwordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppColors.error, fontSize: 14),
                ),
              ],
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'SIGN UP',
                isLoading: _isLoading,
                onPressed: _handleSignup,
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, LoginScreen.routeName),
                  child: const Text('Already have an account? Login'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}