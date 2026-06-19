import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:free_indeed/core/theme/app_theme.dart';

class SermonsScreen extends StatefulWidget {
  const SermonsScreen({super.key});

  @override
  State<SermonsScreen> createState() => _SermonsScreenState();
}

class _SermonsScreenState extends State<SermonsScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Addiction',
    'Identity',
    'Healing',
    'Strength',
    'Grace',
  ];

  final List<Map<String, String>> _sermons = [
    {
      'title': 'Breaking Every Chain',
      'preacher': 'TD Jakes',
      'duration': '47 min',
      'category': 'Addiction',
      'description': 'A powerful message about breaking free from the chains of addiction through the power of God.',
      'url': 'https://www.youtube.com/results?search_query=TD+Jakes+breaking+every+chain',
      'emoji': '⛓️',
    },
    {
      'title': 'You Are Not Your Past',
      'preacher': 'Steven Furtick',
      'duration': '38 min',
      'category': 'Identity',
      'description': 'God sees you not as who you were but who you are becoming. Your identity is in Christ alone.',
      'url': 'https://www.youtube.com/results?search_query=Steven+Furtick+you+are+not+your+past',
      'emoji': '🆔',
    },
    {
      'title': 'The Power of Grace',
      'preacher': 'Joyce Meyer',
      'duration': '52 min',
      'category': 'Grace',
      'description': 'Understanding God\'s grace is the foundation of overcoming any struggle in your life.',
      'url': 'https://www.youtube.com/results?search_query=Joyce+Meyer+power+of+grace',
      'emoji': '🕊️',
    },
    {
      'title': 'Strength in Weakness',
      'preacher': 'Charles Stanley',
      'duration': '41 min',
      'category': 'Strength',
      'description': 'When we are weak, He is strong. Learn how to tap into God\'s strength in your darkest moments.',
      'url': 'https://www.youtube.com/results?search_query=Charles+Stanley+strength+in+weakness',
      'emoji': '💪',
    },
    {
      'title': 'Healing from the Inside Out',
      'preacher': 'Joel Osteen',
      'duration': '29 min',
      'category': 'Healing',
      'description': 'True healing starts from within. God wants to heal not just your body but your mind and spirit.',
      'url': 'https://www.youtube.com/results?search_query=Joel+Osteen+healing+from+inside+out',
      'emoji': '💊',
    },
    {
      'title': 'Freedom from Pornography',
      'preacher': 'Craig Groeschel',
      'duration': '44 min',
      'category': 'Addiction',
      'description': 'A bold, honest message about finding freedom from pornography addiction through Christ.',
      'url': 'https://www.youtube.com/results?search_query=Craig+Groeschel+freedom+pornography',
      'emoji': '🔓',
    },
    {
      'title': 'Winning the War in Your Mind',
      'preacher': 'Craig Groeschel',
      'duration': '36 min',
      'category': 'Strength',
      'description': 'The battle against addiction starts in the mind. Learn how to renew your mind with God\'s Word.',
      'url': 'https://www.youtube.com/results?search_query=Craig+Groeschel+winning+war+mind',
      'emoji': '🧠',
    },
    {
      'title': 'No More Shame',
      'preacher': 'TD Jakes',
      'duration': '55 min',
      'category': 'Grace',
      'description': 'Shame keeps people trapped in addiction. This message will set you free from the weight of shame.',
      'url': 'https://www.youtube.com/results?search_query=TD+Jakes+no+more+shame',
      'emoji': '😌',
    },
    {
      'title': 'Recovering from a Relapse',
      'preacher': 'Rick Warren',
      'duration': '33 min',
      'category': 'Healing',
      'description': 'Relapse is not the end of your story. God\'s mercies are new every morning.',
      'url': 'https://www.youtube.com/results?search_query=Rick+Warren+recovering+relapse',
      'emoji': '🌅',
    },
  ];

  List<Map<String, String>> get _filteredSermons {
    if (_selectedCategory == 'All') return _sermons;
    return _sermons
        .where((s) => s['category'] == _selectedCategory)
        .toList();
  }

  Future<void> _openSermon(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
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
                        'POWER SERMONS',
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
                    'Feed Your\nFaith 🎙️',
                    style: AppTextStyles.displayLarge,
                  ),
                ],
              ),
            ),
          ),

          // Category filter
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.darkBrown,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories.map((category) {
                    final isSelected = _selectedCategory == category;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategory = category),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.gold
                              : AppColors.gold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          category,
                          style: AppTextStyles.caption.copyWith(
                            color: isSelected
                                ? AppColors.darkBrown
                                : AppColors.gold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Sermon list
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final sermon = _filteredSermons[index];
                return _buildSermonCard(sermon);
              },
              childCount: _filteredSermons.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildSermonCard(Map<String, String> sermon) {
    return GestureDetector(
      onTap: () => _openSermon(sermon['url']!),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.mediumBrown,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Emoji thumbnail
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Text(
                  sermon['emoji']!,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sermon['title']!,
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        sermon['preacher']!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '  •  ${sermon['duration']!}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textLight.withValues(alpha: 0.4),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sermon['description']!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textLight.withValues(alpha: 0.6),
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          sermon['category']!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.gold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.gold,
                          shape: BoxShape.circle,
                   ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: AppColors.darkBrown,
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}