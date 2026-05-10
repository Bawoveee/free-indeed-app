import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:free_indeed/core/theme/app_theme.dart';
import 'package:free_indeed/features/ai_guide/ai_guide_screen.dart';

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
  Scaffold(body: Center(child: Text('Devotional - Coming Soon'))),
  Scaffold(body: Center(child: Text('Journal - Coming Soon'))),
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
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.lightBlue,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: 'AI Guide',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Devotional',
          ),
          NavigationDestination(
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book),
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
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good day 🕊️',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      Text(
                        user?.email?.split('@')[0] ?? 'Friend',
                        style: AppTextStyles.heading1,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    icon: const Icon(Icons.logout),
                    color: AppColors.grey,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Daily verse card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.navyBlue, AppColors.royalBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verse of the Day',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.gold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '"I can do all things through Christ who strengthens me."',
                      style: AppTextStyles.scripture.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '— Philippians 4:13',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Quick actions
              Text('Quick Actions', style: AppTextStyles.heading2),
              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: [
                  _buildActionCard(
                    emoji: '🤖',
                    title: 'AI Guide',
                    subtitle: 'Talk to your faith guide',
                    color: AppColors.lightBlue,
                  ),
                  _buildActionCard(
                    emoji: '📖',
                    title: 'Devotional',
                    subtitle: 'Today\'s devotional',
                    color: AppColors.lightGold,
                  ),
                  _buildActionCard(
                    emoji: '🎙️',
                    title: 'Sermons',
                    subtitle: 'Recommended for you',
                    color: AppColors.lightBlue,
                  ),
                  _buildActionCard(
                    emoji: '📔',
                    title: 'Journal',
                    subtitle: 'Write your thoughts',
                    color: AppColors.lightGold,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Sobriety tracker teaser
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 36)),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sobriety Tracker',
                            style: AppTextStyles.heading3),
                        Text(
                          'Start tracking your freedom journey',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyles.heading3),
          Text(subtitle, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}