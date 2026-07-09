import 'package:flutter/material.dart';
import 'package:free_indeed/core/theme/app_theme.dart';

class DevotionalScreen extends StatelessWidget {
  const DevotionalScreen({super.key});

  final List<Map<String, String>> _devotionals = const [
    {
      'day': 'Day 1',
      'title': 'You Are Not Condemned',
      'verse': '"There is therefore now no condemnation for those who are in Christ Jesus."',
      'reference': 'Romans 8:1',
      'reflection': 'Addiction often comes with a crushing weight of shame and guilt. The enemy uses these feelings to keep you trapped — convincing you that you are too far gone, too broken, too dirty for God to love.\n\nBut God\'s Word declares something different. There is NO condemnation. Not a little. Not sometimes. None. When you are in Christ, the verdict has already been spoken over your life — and it is not guilty.\n\nYou are not your addiction. You are not your worst moment. You are a child of God, covered by grace, walking toward freedom.',
      'prayer': 'Lord, today I reject the voice of condemnation. I declare that I am not defined by my past or my struggles. I am Yours, and You have already paid the price for my freedom. Help me walk in that truth today. Amen.',
    },
    {
      'day': 'Day 2',
      'title': 'The Battle Belongs to God',
      'verse': '"For the weapons of our warfare are not carnal but mighty in God for pulling down strongholds."',
      'reference': '2 Corinthians 10:4',
      'reflection': 'Addiction is a stronghold — a fortified place in the mind that has been built up over time through repeated choices, pain, and lies. You cannot break it with willpower alone. Human strength is not enough.\n\nBut God has given us weapons that are mighty — prayer, His Word, worship, community. These are not weak spiritual exercises. They are demolition tools that tear down what the enemy has built.\n\nToday, pick up your weapons. Open the Word. Pray out loud. Worship even when you don\'t feel like it. The battle belongs to God.',
      'prayer': 'Father, I acknowledge that I cannot win this battle in my own strength. I pick up the weapons You have given me today — Your Word, prayer, and faith. Pull down every stronghold in my mind and replace it with Your truth. Amen.',
    },
    {
      'day': 'Day 3',
      'title': 'Rivers in the Desert',
      'verse': '"I will even make a road in the wilderness and rivers in the desert."',
      'reference': 'Isaiah 43:19',
      'reflection': 'Sometimes addiction leaves you feeling like you are in a wasteland — dry, empty, hopeless. You look around and see nothing but desert. No way out. No water. No life.\n\nBut God specializes in deserts. He made water come from a rock for Moses. He fed Elijah under a tree. He makes roads where there are none.\n\nYour situation may look impossible. But God is doing something new — even now, even in this. Look up. A road is being made for you.',
      'prayer': 'God of the impossible, I trust that You are making a way for me even when I cannot see it. Refresh my dry places. Give me hope for the journey ahead. I believe You are working even now. Amen.',
    },
  ];

  Widget _buildDevotionalCard(
      BuildContext context, Map<String, String> devotional) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DevotionalDetailScreen(devotional: devotional),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.all(20),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    devotional['day']!,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.gold,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: AppColors.gold.withValues(alpha: 0.5), size: 14),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              devotional['title']!,
              style: AppTextStyles.heading2.copyWith(
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              devotional['verse']!,
              style: AppTextStyles.scripture.copyWith(fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              devotional['reference']!,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.gold,
                fontWeight: FontWeight.w600,
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
                      'DAILY DEVOTIONAL',
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
                  'The Word\nfor Today',
                  style: AppTextStyles.displayLarge,
                ),
              ],
            ),
          ),

          // SCROLLABLE CONTENT
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 32),
              itemCount: _devotionals.length,
              itemBuilder: (context, index) {
                final devotional = _devotionals[index];
                return _buildDevotionalCard(context, devotional);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DevotionalDetailScreen extends StatelessWidget {
  final Map<String, String> devotional;

  const DevotionalDetailScreen({super.key, required this.devotional});

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
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back_ios,
                          color: AppColors.gold, size: 16),
                      Text(
                        'Back',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.gold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  devotional['day']!,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.gold,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  devotional['title']!,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          '✦  SCRIPTURE  ✦',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.gold,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          devotional['verse']!,
                          style: AppTextStyles.scripture,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          width: 40,
                          height: 1,
                          color: AppColors.gold.withValues(alpha: 0.3),
                        ),
                        Text(
                          devotional['reference']!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.gold,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    '✦  REFLECTION  ✦',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    devotional['reflection']!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      height: 1.8,
                      color: AppColors.darkBrown,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.parchmentDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '🙏  PRAYER FOR TODAY',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textMuted,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          devotional['prayer']!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            height: 1.8,
                            fontStyle: FontStyle.italic,
                            color: AppColors.darkBrown,
                          ),
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