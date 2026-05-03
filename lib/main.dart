import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:free_indeed/core/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: FreeIndeedApp(),
    ),
  );
}

class FreeIndeedApp extends StatelessWidget {
  const FreeIndeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Free Indeed',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🕊️',
              style: TextStyle(fontSize: 72),
            ),
            const SizedBox(height: 24),
            Text(
              'Free Indeed',
              style: AppTextStyles.displayLarge,
            ),
            const SizedBox(height: 12),
            Text(
              '"You shall know the truth, and the truth\nshall set you free." — John 8:32',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.white.withValues(alpha: 0.7),
fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}