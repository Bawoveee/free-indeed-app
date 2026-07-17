import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Sermon {
  final String title;
  final String channelTitle;
  final String thumbnailUrl;
  final String videoId;

  Sermon({
    required this.title,
    required this.channelTitle,
    required this.thumbnailUrl,
    required this.videoId,
  });

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$videoId';
}

class SermonService {
  static Future<List<Sermon>> searchSermons(String query) async {
    final apiKey = dotenv.env['YOUTUBE_API_KEY'];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('YouTube API key not found. Check your .env file.');
    }

    final searchQuery = '$query sermon';
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/search'
      '?part=snippet'
      '&type=video'
      '&maxResults=20'
      '&q=${Uri.encodeComponent(searchQuery)}'
      '&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load sermons: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final items = data['items'] as List;

    return items.map((item) {
      final snippet = item['snippet'];
      final videoId = item['id']['videoId'];
      return Sermon(
        title: snippet['title'] ?? '',
        channelTitle: snippet['channelTitle'] ?? '',
        thumbnailUrl: snippet['thumbnails']['medium']['url'] ?? '',
        videoId: videoId ?? '',
      );
    }).toList();
  }
}