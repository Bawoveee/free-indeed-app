import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:free_indeed/features/home/home_screen.dart';
import 'package:free_indeed/features/onboarding/onboarding_screen.dart';
import 'package:free_indeed/features/onboarding/addiction_selection_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              final data =
                  userSnapshot.data?.data() as Map<String, dynamic>?;
             final onboardingComplete =
    data?['onboardingComplete'] ?? false;
final hasAddiction = data?['addictionType'] != null;

if (onboardingComplete || hasAddiction) {
  return const HomeScreen();
}
return const AddictionSelectionScreen();
            },
          );
        }
        return const OnboardingScreen();
      },
    );
  }
}