import 'package:flutter/material.dart';
import '../../common/constants/app_styles.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.surface,
              child: Icon(Icons.person, size: 60, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            const Text('Ahmed Explorer', style: AppTextStyles.h1),
            const Text('hunter@example.com', style: AppTextStyles.caption),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Rank', 'Gold'),
                _buildStatCard('Points', '1,250'),
                _buildStatCard('Treasures', '12'),
              ],
            ),
            const SizedBox(height: 40),
            _buildProfileOption(Icons.edit_outlined, 'Edit Profile'),
            _buildProfileOption(Icons.history_outlined, 'Hunt History'),
            _buildProfileOption(Icons.settings_outlined, 'Settings'),
            const Divider(height: 48),
            _buildProfileOption(Icons.logout, 'Logout', color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.onBackground),
      title: Text(title, style: TextStyle(color: color ?? AppColors.onBackground)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: () {},
    );
  }
}
