import 'package:flutter/material.dart';
import 'common/constants/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/home/home_screen.dart';
import 'features/treasures/ar_view_screen.dart';
import 'features/treasures/treasure_screens.dart';
import 'features/profile/profile_screen.dart';

import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'features/treasures/home_screen_logic.dart';
import 'features/treasures/treasure_ar_logic.dart';

class TreasureQuestApp extends StatelessWidget {
  const TreasureQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => HomeScreenLogic()),
        ChangeNotifierProvider(create: (_) => TreasureARLogic()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Treasure Quest',
        theme: AppTheme.darkTheme,
      initialRoute: SignupScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignupScreen.routeName: (context) => const SignupScreen(),
        TreasureScreen.routeName: (context) => const TreasureScreen(),
        ARViewScreen.routeName: (context) => const ARViewScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
      },
      )
    );
  }
}
