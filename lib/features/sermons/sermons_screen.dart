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
      'title': 'Prayer to be Free from Addiction',
      'preacher': 'Apostle Joshua Selman',
      'duration': '38 min',
      'category': 'Addiction',
      'description': 'Apostle Joshua Selman leads a powerful prayer for freedom from every addiction.',
      'videoId': '---ISWEs4aw',
      'url': 'https://www.youtube.com/watch?v=---ISWEs4aw',
    },
    {
      'title': 'Enjoying Complete Deliverance',
      'preacher': 'Apostle Joshua Selman',
      'duration': '45 min',
      'category': 'Addiction',
      'description': 'A powerful teaching on enjoying complete deliverance from every stronghold.',
      'videoId': 'yT47DJpRjEQ',
      'url': 'https://www.youtube.com/watch?v=yT47DJpRjEQ',
    },
    {
      'title': 'The Power of Deliverance',
      'preacher': 'Apostle Joshua Selman',
      'duration': '52 min',
      'category': 'Strength',
      'description': 'Understanding the power of God available to set you free from every bondage.',
      'videoId': 'Ny8JiUUKukg',
      'url': 'https://www.youtube.com/watch?v=Ny8JiUUKukg',
    },
    {
      'title': 'Signs You Need Total Change',
      'preacher': 'Apostle Joshua Selman',
      'duration': '41 min',
      'category': 'Identity',
      'description': 'A word for anyone who knows they need a total transformation in their life.',
      'videoId': 'YSt8sifVZSo',
      'url': 'https://www.youtube.com/watch?v=YSt8sifVZSo',
    },
    {
      'title': 'River of Wisdom',
      'preacher': 'Bishop David Oyedepo',
      'duration': '58 min',
      'category': 'Strength',
      'description': 'Bishop Oyedepo ministers on accessing divine wisdom to overcome every challenge.',
      'videoId': 'mmqgRY0egeA',
      'url': 'https://www.youtube.com/watch?v=mmqgRY0egeA',
    },
    {
      'title': 'This Message Will Change Your Level',
      'preacher': 'Bishop David Oyedepo',
      'duration': '47 min',
      'category': 'Identity',
      'description': 'A powerful word to take you to a new level in your walk with God.',
      'videoId': 'Acg0tK3nouA',
      'url': 'https://www.youtube.com/watch?v=Acg0tK3nouA',
    },
    {
      'title': 'Powerful Sermon for May 2024',
      'preacher': 'Apostle Joshua Selman',
      'duration': '36 min',
      'category': 'Grace',
      'description': 'A timely word to prepare you for breakthrough and freedom in every area.',
      'videoId': 'YMoxayNwZ64',
      'url': 'https://www.youtube.com/watch?v=YMoxayNwZ64',
    },
    {
      'title': 'God Is Preparing You in Secret',
      'preacher': 'Apostle Joshua Selman',
      'duration': '44 min',
      'category': 'Healing',
      'description': 'Don\'t give up — God is working behind the scenes for your total freedom.',
      'videoId': 'aNyZa6f7Dec',
      'url': 'https://www.youtube.com/watch?v=aNyZa6f7Dec',
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
      body: Column(
        children: [
          // FIXED HEADER
          Container(
            color: AppColors.darkBrown,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 56, 24, 16),
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
                // Category filter
                Padding(
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
              ],
            ),
          ),

          // SCROLLABLE CONTENT
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 32),
              itemCount: _filteredSermons.length,
              itemBuilder: (context, index) {
                final sermon = _filteredSermons[index];
                return _buildSermonCard(sermon);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSermonCard(Map<String, String> sermon) {
    final thumbnailUrl =
        'https://img.youtube.com/vi/${sermon['videoId']}/hqdefault.jpg';

    return GestureDetector(
      onTap: () => _openSermon(sermon['url']!),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        decoration: BoxDecoration(
          color: AppColors.mediumBrown,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Stack(
                children: [
                  Image.network(
                    thumbnailUrl,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 180,
                      color: AppColors.darkBrown,
                      child: const Center(
                        child: Icon(Icons.play_circle_outline,
                            color: AppColors.gold, size: 48),
                      ),
                    ),
                  ),
                  // Play button overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.darkBrown.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: AppColors.darkBrown,
                        size: 20,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.darkBrown.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        sermon['duration']!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textLight,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(14),
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
                        '  •  ${sermon['category']!}',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}