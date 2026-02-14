import 'package:flutter/material.dart';
import '../../common/constants/app_styles.dart';
import '../../services/firestore_service.dart';
import '../auth/auth_service.dart';
import 'change_password_screen.dart';
import 'legal_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkMode = true; // Assuming default app theme is dark

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Preferences'),
          _buildSwitchTile(
            'Notifications',
            'Receive alerts for nearby treasures',
            _notificationsEnabled,
            (val) => setState(() => _notificationsEnabled = val),
          ),
          // Theme switch removed for now as app is forced dark, can be added later if light mode is supported.
          
          const SizedBox(height: 24),
          _buildSectionHeader('Account'),
          ListTile(
            title: const Text('Privacy Policy', style: TextStyle(color: AppColors.onBackground)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LegalScreen(
                    title: 'Privacy Policy',
                    content: dummyPrivacyPolicy,
                  ),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Terms of Service', style: TextStyle(color: AppColors.onBackground)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LegalScreen(
                    title: 'Terms of Service',
                    content: dummyTermsOfService,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Treasure Quest v1.0.0',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      activeColor: AppColors.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text(title, style: const TextStyle(color: AppColors.onBackground, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      value: value,
      onChanged: onChanged,
    );
  }
}
