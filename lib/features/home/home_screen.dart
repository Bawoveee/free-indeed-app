import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confetti/confetti.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:free_indeed/core/theme/app_theme.dart';
import 'package:free_indeed/features/journal/journal_screen.dart';
import 'package:free_indeed/features/ai_guide/ai_guide_screen.dart';
import 'package:free_indeed/features/devotional/devotional_screen.dart';
import 'package:free_indeed/features/sermons/sermons_screen.dart';
import 'package:free_indeed/features/tracker/tracker_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    const HomeDashboard(),
    const AiGuideScreen(),
    const DevotionalScreen(),
    const SermonsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        backgroundColor: AppColors.darkBrown,
        indicatorColor: AppColors.gold.withValues(alpha: 0.2),
        height: 65,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.caption.copyWith(color: AppColors.gold);
          }
          return AppTextStyles.caption
              .copyWith(color: AppColors.gold.withValues(alpha: 0.4));
        }),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: Color(0x66D4A843)),
            selectedIcon: Icon(Icons.home, color: Color(0xFFD4A843)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined, color: Color(0x66D4A843)),
            selectedIcon: Icon(Icons.auto_awesome, color: Color(0xFFD4A843)),
            label: 'Guide',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined, color: Color(0x66D4A843)),
            selectedIcon: Icon(Icons.menu_book, color: Color(0xFFD4A843)),
            label: 'Word',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined, color: Color(0x66D4A843)),
            selectedIcon: Icon(Icons.book, color: Color(0xFFD4A843)),
            label: 'Sermons',
          ),
        ],
      ),
    );
  }
}

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _streakAnimController;
  late Animation<double> _streakAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _streakAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _streakAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
          parent: _streakAnimController, curve: Curves.easeInOut),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _streakAnimController.dispose();
    super.dispose();
  }

  Widget _buildActionCard({
    required String emoji,
    required String title,
    required String subtitle,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBrown : AppColors.parchmentDark,
          borderRadius: BorderRadius.circular(16),
          border: isDark
              ? Border.all(color: AppColors.gold.withValues(alpha: 0.15))
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.heading3.copyWith(
                color: isDark ? AppColors.textLight : AppColors.darkBrown,
              ),
            ),
            Text(
              subtitle,
              style: AppTextStyles.caption.copyWith(
                color: isDark
                    ? AppColors.textLight.withValues(alpha: 0.5)
                    : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: Stack(
        children: [
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [
                AppColors.gold,
                AppColors.darkBrown,
                Colors.white,
              ],
              numberOfParticles: 20,
              gravity: 0.3,
            ),
          ),

          // Main content
          Column(
            children: [
              // FIXED HEADER
              Container(
                padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
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
                    const SizedBox(height: 16),
                    Text(
                      'Good day, warrior',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.gold.withValues(alpha: 0.7),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      FirebaseAuth.instance.currentUser?.displayName ??
                          FirebaseAuth.instance.currentUser?.email
                              ?.split('@')[0] ??
                          'Friend',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Animated streak badge
                    ScaleTransition(
                      scale: _streakAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🔥',
                                style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            AnimatedTextKit(
                              animatedTexts: [
                                FadeAnimatedText(
                                  '7 days of freedom!',
                                  textStyle: AppTextStyles.caption.copyWith(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  duration:
                                      const Duration(milliseconds: 2000),
                                ),
                                FadeAnimatedText(
                                  'Keep going warrior! 💪',
                                  textStyle: AppTextStyles.caption.copyWith(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  duration:
                                      const Duration(milliseconds: 2000),
                                ),
                              ],
                              repeatForever: true,
                              isRepeatingAnimation: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // SCROLLABLE CONTENT
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Verse card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: AppColors.mediumBrown,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '✦  VERSE OF THE DAY  ✦',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.gold,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '"No weapon formed against you shall prosper, and every tongue that rises against you in judgment you shall condemn."',
                              style: AppTextStyles.scripture,
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10),
                              width: 40,
                              height: 1,
                              color: AppColors.gold.withValues(alpha: 0.3),
                            ),
                            Text(
                              'Isaiah 54:17',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.gold,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Arsenal section
                      Text(
                        '✦  YOUR ARSENAL  ✦',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.2,
                        children: [
                          _buildActionCard(
                            emoji: '🤖',
                            title: 'AI Guide',
                            subtitle: 'Talk to Grace',
                            isDark: true,
                          ),
                          _buildActionCard(
                            emoji: '📖',
                            title: 'Devotional',
                            subtitle: "Today's word",
                            isDark: false,
                          ),
                          _buildActionCard(
                            emoji: '🎙️',
                            title: 'Sermons',
                            subtitle: 'Power messages',
                            isDark: false,
                          ),
                          _buildActionCard(
                            emoji: '📔',
                            title: 'Journal',
                            subtitle: 'Your victories',
                            isDark: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const JournalScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Freedom tracker
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TrackerScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.darkBrown,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.gold.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Freedom Tracker',
                                      style: AppTextStyles.heading2.copyWith(
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Tap to track your journey',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textLight
                                            .withValues(alpha: 0.5),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(2),
                                      child: LinearProgressIndicator(
                                        value: 0.35,
                                        backgroundColor: AppColors.gold
                                            .withValues(alpha: 0.15),
                                        valueColor: const AlwaysStoppedAnimation<Color>(
                                          AppColors.gold,
                                        ),
                                        minHeight: 3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                children: [
                                  const Text(
                                    '🏆',
                                    style: TextStyle(fontSize: 32),
                                  ),
                                  Text(
                                    'VIEW',
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.gold
                                          .withValues(alpha: 0.6),
                                      letterSpacing: 1,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Sermon recommendation
                      Text(
                        '✦  RECOMMENDED SERMON  ✦',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.parchmentDark,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.darkBrown,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text('🎙️',
                                    style: TextStyle(fontSize: 22)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Breaking Every Chain',
                                    style: AppTextStyles.heading3,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Apostle Joshua Selman',
                                    style: AppTextStyles.caption,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(
                                color: AppColors.darkBrown,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(Icons.play_arrow,
                                    color: AppColors.gold, size: 18),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Sign out
                      TextButton.icon(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        icon: const Icon(Icons.logout,
                            color: AppColors.textMuted, size: 16),
                        label: Text(
                          'Sign Out',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.textMuted),
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}