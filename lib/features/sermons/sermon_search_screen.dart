import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:free_indeed/core/theme/app_theme.dart';
import 'package:free_indeed/features/sermons/sermon_service.dart';

class SermonSearchScreen extends StatefulWidget {
  const SermonSearchScreen({super.key});

  @override
  State<SermonSearchScreen> createState() => _SermonSearchScreenState();
}

class _SermonSearchScreenState extends State<SermonSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Sermon> _results = [];
  bool _isLoading = false;
  String? _error;

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await SermonService.searchSermons(query.trim());
      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Something went wrong. Please try again.';
        _isLoading = false;
      });
    }
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
          // HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
            color: AppColors.darkBrown,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find a Sermon 🎙️',
                  style: AppTextStyles.displayLarge,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: _search,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search by topic e.g. forgiveness, addiction',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: AppColors.mediumBrown,
                    prefixIcon: const Icon(Icons.search, color: AppColors.gold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward, color: AppColors.gold),
                      onPressed: () => _search(_searchController.text),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // RESULTS
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Text(
                          _error!,
                          style: AppTextStyles.bodySmall,
                        ),
                      )
                    : _results.isEmpty
                        ? Center(
                            child: Text(
                              'Search for a topic to find sermons',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.darkBrown.withValues(alpha: 0.5),
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _results.length,
                            itemBuilder: (context, index) {
                              final sermon = _results[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(8),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: sermon.thumbnailUrl,
                                      width: 90,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title: Text(
                                    sermon.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Text(
                                    sermon.channelTitle,
                                    style: AppTextStyles.caption,
                                  ),
                                  onTap: () => _openSermon(sermon.youtubeUrl),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}