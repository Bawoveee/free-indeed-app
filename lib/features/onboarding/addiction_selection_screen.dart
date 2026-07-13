import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:free_indeed/core/theme/app_theme.dart';
import 'package:free_indeed/features/home/home_screen.dart';

class AddictionSelectionScreen extends StatefulWidget {
  const AddictionSelectionScreen({super.key});

  @override
  State<AddictionSelectionScreen> createState() =>
      _AddictionSelectionScreenState();
}

class _AddictionSelectionScreenState
    extends State<AddictionSelectionScreen> {
  String? _selectedAddiction;
  bool _isSaving = false;

  final List<Map<String, String>> _addictions = [
    {'emoji': '🍺', 'title': 'Alcohol', 'key': 'alcohol'},
    {'emoji': '💊', 'title': 'Drugs', 'key': 'drugs'},
    {'emoji': '📱', 'title': 'Pornography', 'key': 'pornography'},
    {'emoji': '🎰', 'title': 'Gambling', 'key': 'gambling'},
    {'emoji': '🚬', 'title': 'Smoking', 'key': 'smoking'},
    {'emoji': '📲', 'title': 'Social Media', 'key': 'social_media'},
    {'emoji': '🍔', 'title': 'Food', 'key': 'food'},
    {'emoji': '🎮', 'title': 'Gaming', 'key': 'gaming'},
    {'emoji': '💸', 'title': 'Spending', 'key': 'spending'},
    {'emoji': '😤', 'title': 'Anger', 'key': 'anger'},
    {'emoji': '💔', 'title': 'Relationships', 'key': 'relationships'},
    {'emoji': '🌑', 'title': 'Other', 'key': 'other'},
  ];

  Future<void> _saveAndContinue() async {
    if (_selectedAddiction == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your struggle to continue'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .set({
        'addictionType': _selectedAddiction,
        'onboardingComplete': true,
      }, SetOptions(merge: true));

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    if (mounted) setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: Column(
        children: [
          // FIXED HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
            color: AppColors.darkBrown,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('✝',
                        style: TextStyle(
                            color: Color(0xFFD4A843), fontSize: 12)),
                    const SizedBox(width: 6),
                    Text(
                      'FREE INDEED',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.gold,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'What are you\nfighting? 🛡️',
                  style: AppTextStyles.displayLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Select your struggle. This helps us personalize your journey. Only you can see this.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textLight.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),

          // SCROLLABLE CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.95,
                    children: _addictions.map((addiction) {
                      final isSelected =
                          _selectedAddiction == addiction['key'];
                      return GestureDetector(
                        onTap: () => setState(
                            () => _selectedAddiction = addiction['key']),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.darkBrown
                                : AppColors.parchmentDark,
                            borderRadius: BorderRadius.circular(16),
                            border: isSelected
                                ? Border.all(
                                    color: AppColors.gold,
                                    width: 2,
                                  )
                                : Border.all(
                                    color: AppColors.gold
                                        .withValues(alpha: 0.1),
                                  ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                addiction['emoji']!,
                                style: const TextStyle(fontSize: 28),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                addiction['title']!,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.caption.copyWith(
                                  color: isSelected
                                      ? AppColors.gold
                                      : AppColors.darkBrown,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.gold,
                                  size: 16,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Privacy note
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.mediumBrown,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Text('🔒',
                            style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your selection is private and secure. It is never shared with anyone.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color:
                                  AppColors.textLight.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveAndContinue,
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Begin My Journey 🕊️'),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}