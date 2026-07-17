import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:free_indeed/core/theme/app_theme.dart';
import 'package:free_indeed/features/sermons/sermon_service.dart';
import 'package:free_indeed/features/sermons/spotify_service.dart';

class SermonSearchScreen extends StatefulWidget {
  const SermonSearchScreen({super.key});

  @override
  State<SermonSearchScreen> createState() => _SermonSearchScreenState();
}

class _SermonSearchScreenState extends State<SermonSearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  List<Sermon> _videoResults = [];
  List<SpotifyTrack> _audioResults = [];
  bool _isLoading = false;
  String? _error;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
      _hasSearched = true;
    });

    try {
      final results = await Future.wait([
        SermonService.searchSermons(query.trim()),
        SpotifyService.searchSermons(query.trim()),
      ]);

      setState(() {
        _videoResults = results[0] as List<Sermon>;
        _audioResults = results[1] as List<SpotifyTrack>;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('SERMON SEARCH ERROR: $e');
      setState(() {
        _error = 'Something went wrong. Please try again.';
        _isLoading = false;
      });
    }
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.darkBrown.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoList() {
    if (_videoResults.isEmpty) {
      return _buildEmptyState('No video sermons found. Try another topic.');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _videoResults.length,
      itemBuilder: (context, index) {
        final sermon = _videoResults[index];
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
            onTap: () => _openUrl(sermon.youtubeUrl),
          ),
        );
      },
    );
  }

  Widget _buildAudioList() {
    if (_audioResults.isEmpty) {
      return _buildEmptyState('No audio sermons found. Try another topic.');
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _audioResults.length,
      itemBuilder: (context, index) {
        final track = _audioResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: track.imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: track.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      color: AppColors.darkBrown,
                      child: const Icon(Icons.music_note,
                          color: AppColors.gold),
                    ),
            ),
            title: Text(
              track.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              track.artist,
              style: AppTextStyles.caption,
            ),
            trailing: const Icon(Icons.play_circle_outline,
                color: AppColors.gold),
            onTap: () => _openUrl(track.spotifyUrl),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.parchment,
      body: Column(
        children: [
          // HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 0),
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
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.gold),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward,
                          color: AppColors.gold),
                      onPressed: () => _search(_searchController.text),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppColors.gold,
                  labelColor: AppColors.gold,
                  unselectedLabelColor:
                      Colors.white.withValues(alpha: 0.5),
                  tabs: const [
                    Tab(icon: Icon(Icons.videocam), text: 'Video'),
                    Tab(icon: Icon(Icons.headphones), text: 'Audio'),
                  ],
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
                    : !_hasSearched
                        ? _buildEmptyState(
                            'Search for a topic to find sermons')
                        : TabBarView(
                            controller: _tabController,
                            children: [
                              _buildVideoList(),
                              _buildAudioList(),
                            ],
                          ),
          ),
        ],
      ),
    );
  }
}