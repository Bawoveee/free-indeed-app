import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:free_indeed/core/theme/app_theme.dart';
import 'package:free_indeed/features/ai_guide/ai_guide_screen.dart';
import 'package:free_indeed/features/devotional/devotional_screen.dart';

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
    const Scaffold(body: Center(child: Text('Journal - Coming Soon'))),
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
            label: 'Journal',
          ),
        ],
      ),
    );
  }
}

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
              decoration: const BoxDecoration(
                color: AppColors.darkBrown,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cross and app name
                  Row(
                    children: [
                      const Text('✝',
                          style:
                              TextStyle(color: Color(0xFFD4A843), fontSize: 12)),
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
                    user?.email?.split('@')[0] ?? 'Friend',
                    style: GoogleFontsHelper.playfair(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Streak badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 13)),
                        const SizedBox(width: 6),
                        Text(
                          '7 days of freedom',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Verse card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
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
                      margin: const EdgeInsets.symmetric(vertical: 10),
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
            ),
          ),

          // Arsenal section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    childAspectRatio: 1.8,
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Freedom tracker
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Freedom Tracker',
                            style: AppTextStyles.heading2.copyWith(
                              color: AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'You are winning this battle',
                            style: AppTextStyles.caption.copyWith(
                              color:
                                  AppColors.textLight.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: 0.35,
                              backgroundColor:
                                  AppColors.gold.withValues(alpha: 0.15),
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
                        Text(
                          '7',
                          style: GoogleFontsHelper.playfair(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: AppColors.gold,
                          ),
                        ),
                        Text(
                          'DAYS FREE',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textLight.withValues(alpha: 0.4),
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
          ),

          // Sermon recommendation
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            child:
                                Text('🎙️', style: TextStyle(fontSize: 22)),
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
                                'TD Jakes • 47 min',
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
                ],
              ),
            ),
          ),

          // Sign out
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: TextButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout,
                    color: AppColors.textMuted, size: 16),
                label: Text(
                  'Sign Out',
                  style:
                      AppTextStyles.caption.copyWith(color: AppColors.textMuted),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String emoji,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
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
    );
  }
}

class GoogleFontsHelper {
  static TextStyle playfair({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
  }) {
    return TextStyle(
      fontFamily: 'Playfair Display',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}