import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:free_indeed/features/home/home_screen.dart';
import 'package:free_indeed/features/onboarding/onboarding_screen.dart';
import 'package:free_indeed/features/onboarding/addiction_selection_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _hasDocument = false;

  @override
  void initState() {
    super.initState();
    _checkUserDocument();
  }

  Future<void> _checkUserDocument() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _hasDocument = doc.exists;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasDocument = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF1A0F0A),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFD4A843)),
        ),
      );
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const OnboardingScreen();
    }

    if (_hasDocument) {
      return const HomeScreen();
    }

    return const AddictionSelectionScreen();
  }
}