import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/constants/app_styles.dart';
import '../../providers/user_provider.dart';
import '../auth/auth_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

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
            Text(user?.name ?? 'Anonymous Hunter', style: AppTextStyles.h1),
            Text(user?.email ?? 'No Email', style: AppTextStyles.caption),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatCard('Rank', 'Beginner'),
                _buildStatCard('Points', (user?.points ?? 0).toString()),
                _buildStatCard('Treasures', (user?.treasures.length ?? 0).toString()),
              ],
            ),
            const SizedBox(height: 40),
            _buildProfileOption(Icons.edit_outlined, 'Edit Profile', onTap: () {}),
            _buildProfileOption(Icons.history_outlined, 'Hunt History', onTap: () {}),
            _buildProfileOption(Icons.settings_outlined, 'Settings', onTap: () {}),
            const Divider(height: 48),
            _buildProfileOption(
              Icons.logout, 
              'Logout', 
              color: Colors.red,
              onTap: () async {
                await AuthService().signOut();
                userProvider.clearUser();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
                }
              },
            ),
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

  Widget _buildProfileOption(IconData icon, String title, {Color? color, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.onBackground),
      title: Text(title, style: TextStyle(color: color ?? AppColors.onBackground)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }
}
