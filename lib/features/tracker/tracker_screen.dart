import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:free_indeed/core/theme/app_theme.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  DateTime? _startDate;
  bool _isLoading = true;

  final List<Map<String, dynamic>> _milestones = [
    {'days': 1, 'emoji': '🌱', 'title': 'Day One'},
    {'days': 7, 'emoji': '🔥', 'title': 'One Week'},
    {'days': 30, 'emoji': '⭐', 'title': 'One Month'},
    {'days': 90, 'emoji': '🏆', 'title': '90 Days'},
    {'days': 180, 'emoji': '💎', 'title': '6 Months'},
    {'days': 365, 'emoji': '👑', 'title': 'One Year'},
  ];

  @override
  void initState() {
    super.initState();
    _loadStartDate();
  }

  Future<void> _loadStartDate() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data()?['freedomStartDate'] != null) {
        setState(() {
          _startDate = (doc.data()!['freedomStartDate'] as Timestamp).toDate();
          _isLoading = false;
        });
      } else {
        // First time - set start date to today
        await _setStartDate(DateTime.now());
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _setStartDate(DateTime date) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'freedomStartDate': Timestamp.fromDate(date),
    }, SetOptions(merge: true));

    setState(() {
      _startDate = date;
      _isLoading = false;
    });
  }

  int get _daysFree {
    if (_startDate == null) return 0;
    return DateTime.now().difference(_startDate!).inDays;
  }

  Future<void> _logRelapse() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.mediumBrown,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'You Are Not Alone 🙏',
          style: AppTextStyles.heading2.copyWith(color: AppColors.textLight),
        ),
        content: Text(
          'Relapse is not failure. It\'s part of the journey. God\'s mercies are new every morning, and so is your freedom journey.\n\nYour counter will reset, but your progress in faith never resets. Are you ready to start fresh today?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textLight.withValues(alpha: 0.8),
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textLight.withValues(alpha: 0.6),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _setStartDate(DateTime.now());
              if (!mounted) return; {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Fresh start! God\'s grace covers you. 🕊️'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            child: const Text('Start Fresh'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.parchment,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.gold),
        ),
      );
    }

    final daysFree = _daysFree;
    final nextMilestone = _milestones.firstWhere(
      (m) => m['days'] > daysFree,
      orElse: () => _milestones.last,
    );
    final progress = daysFree / nextMilestone['days'];

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
                      'FREEDOM TRACKER',
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
                  'Your Victory\nJourney 🏆',
                  style: AppTextStyles.displayLarge,
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
                  // Big counter card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.darkBrown, AppColors.mediumBrown],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          daysFree == 0 ? '🌱' : '🔥',
                          style: const TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '$daysFree',
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.w800,
                            color: AppColors.gold,
                          ),
                        ),
                        Text(
                          daysFree == 1 ? 'DAY FREE' : 'DAYS FREE',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textLight.withValues(alpha: 0.6),
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'You are winning this battle, one day at a time.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textLight.withValues(alpha: 0.8),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Progress to next milestone
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Next: ${nextMilestone['title']}',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.gold,
                                  ),
                                ),
                                Text(
                                  '${nextMilestone['days'] - daysFree} days to go',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textLight
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress.clamp(0.0, 1.0),
                                backgroundColor:
                                    AppColors.gold.withValues(alpha: 0.15),
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                  AppColors.gold,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Milestones grid
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '✦  YOUR MILESTONES  ✦',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textMuted,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                    children: _milestones.map((milestone) {
                      final achieved = daysFree >= milestone['days'];
                      return Container(
                        decoration: BoxDecoration(
                          color: achieved
                              ? AppColors.darkBrown
                              : AppColors.parchmentDark,
                          borderRadius: BorderRadius.circular(16),
                          border: achieved
                              ? Border.all(
                                  color:
                                      AppColors.gold.withValues(alpha: 0.4))
                              : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              milestone['emoji'],
                              style: TextStyle(
                                fontSize: 28,
                                color: achieved ? null : Colors.grey[400],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              milestone['title'],
                              textAlign: TextAlign.center,
                              style: AppTextStyles.caption.copyWith(
                                color: achieved
                                    ? AppColors.gold
                                    : AppColors.textMuted,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Relapse button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.parchmentDark,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Had a setback?',
                          style: AppTextStyles.heading3,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'It\'s okay. God\'s grace is bigger than any relapse. Be honest and start fresh.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton(
                          onPressed: _logRelapse,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.darkBrown,
                            side: BorderSide(
                              color: AppColors.darkBrown.withValues(alpha: 0.3),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('I Need to Start Fresh'),
                        ),
                      ],
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