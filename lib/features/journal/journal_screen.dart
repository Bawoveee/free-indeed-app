import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:free_indeed/core/theme/app_theme.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
                      'MY JOURNAL',
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
                  'Your Victory\nDiary 📔',
                  style: AppTextStyles.displayLarge,
                ),
              ],
            ),
          ),

          // JOURNAL ENTRIES
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('journals')
                  .where('userId', isEqualTo: user?.uid)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.gold),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('📔',
                            style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 16),
                        Text(
                          'No entries yet',
                          style: AppTextStyles.heading2,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap the + button to write\nyour first journal entry',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final entries = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry =
                        entries[index].data() as Map<String, dynamic>;
                    final entryId = entries[index].id;
                    final date =
                        (entry['createdAt'] as Timestamp?)?.toDate() ??
                            DateTime.now();

                    return _buildJournalCard(
                        context, entry, entryId, date);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const WriteJournalScreen(),
            ),
          );
        },
        backgroundColor: AppColors.gold,
        child: const Icon(Icons.edit, color: AppColors.darkBrown),
      ),
    );
  }

  Widget _buildJournalCard(BuildContext context,
      Map<String, dynamic> entry, String entryId, DateTime date) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JournalDetailScreen(
              entry: entry,
              entryId: entryId,
            ),
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
                Text(
                  _formatDate(date),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: AppColors.gold.withValues(alpha: 0.5),
                    size: 14),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              entry['title'] ?? 'Untitled',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              entry['content'] ?? '',
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
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class WriteJournalScreen extends StatefulWidget {
  const WriteJournalScreen({super.key});

  @override
  State<WriteJournalScreen> createState() => _WriteJournalScreenState();
}

class _WriteJournalScreenState extends State<WriteJournalScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something first')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('journals').add({
        'userId': user?.uid,
        'title': _titleController.text.trim().isEmpty
            ? 'My Thoughts'
            : _titleController.text.trim(),
        'content': _contentController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Journal entry saved! 🙏'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving: $e')),
      );
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
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
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
                  'New Entry',
                  style: AppTextStyles.displayLarge,
                ),
              ],
            ),
          ),

          // WRITE AREA
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Title field
                  TextField(
                    controller: _titleController,
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.darkBrown,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Title (optional)',
                      hintStyle: AppTextStyles.heading2.copyWith(
                        color: AppColors.textMuted,
                      ),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: AppColors.parchmentDark,
                      contentPadding: const EdgeInsets.all(16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.gold.withValues(alpha: 0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Content field
                  TextField(
                    controller: _contentController,
                    maxLines: 15,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.darkBrown,
                      height: 1.8,
                    ),
                    decoration: InputDecoration(
                      hintText:
                          'Write your thoughts, prayers, victories or struggles here...\n\nThis is your safe space. Be honest with God and yourself.',
                      hintStyle: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                        height: 1.8,
                      ),
                      filled: true,
                      fillColor: AppColors.parchmentDark,
                      contentPadding: const EdgeInsets.all(16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.gold.withValues(alpha: 0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveEntry,
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Save Entry 🙏'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class JournalDetailScreen extends StatelessWidget {
  final Map<String, dynamic> entry;
  final String entryId;

  const JournalDetailScreen({
    super.key,
    required this.entry,
    required this.entryId,
  });

  Future<void> _deleteEntry(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.mediumBrown,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Delete Entry?',
          style: AppTextStyles.heading2.copyWith(color: AppColors.textLight),
        ),
        content: Text(
          'This entry will be permanently deleted.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textLight.withValues(alpha: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textLight.withValues(alpha: 0.6),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('journals')
          .doc(entryId)
          .delete();
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = (entry['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: Column(
        children: [
          // FIXED HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
            color: AppColors.darkBrown,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    IconButton(
                      onPressed: () => _deleteEntry(context),
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.error),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${months[date.month - 1]} ${date.day}, ${date.year}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.gold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  entry['title'] ?? 'My Thoughts',
                  style: AppTextStyles.displayLarge,
                ),
              ],
            ),
          ),

          // CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Text(
                entry['content'] ?? '',
                style: AppTextStyles.bodyLarge.copyWith(
                  height: 1.9,
                  color: AppColors.darkBrown,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}