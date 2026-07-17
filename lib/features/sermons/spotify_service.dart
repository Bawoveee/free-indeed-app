import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SpotifyTrack {
  final String title;
  final String artist;
  final String imageUrl;
  final String spotifyUrl;

  SpotifyTrack({
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.spotifyUrl,
  });
}

class SpotifyService {
  static String? _accessToken;
  static DateTime? _tokenExpiry;

  static Future<String> _getAccessToken() async {
    // Reuse token if still valid
    if (_accessToken != null &&
        _tokenExpiry != null &&
        DateTime.now().isBefore(_tokenExpiry!)) {
      return _accessToken!;
    }

    final clientId = dotenv.env['SPOTIFY_CLIENT_ID'];
    final clientSecret = dotenv.env['SPOTIFY_CLIENT_SECRET'];

    if (clientId == null || clientSecret == null) {
      throw Exception('Spotify credentials not found. Check your .env file.');
    }

    final credentials = base64Encode(utf8.encode('$clientId:$clientSecret'));

    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get Spotify token: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    _accessToken = data['access_token'];
    _tokenExpiry =
        DateTime.now().add(Duration(seconds: data['expires_in'] - 60));

    return _accessToken!;
  }

  static Future<List<SpotifyTrack>> searchSermons(String query) async {
    final token = await _getAccessToken();
    final searchQuery = '$query sermon';

    final url = Uri.parse(
      'https://api.spotify.com/v1/search'
      '?q=${Uri.encodeComponent(searchQuery)}'
      '&type=track'
      '&limit=10',
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load Spotify results: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final items = data['tracks']['items'] as List;

    return items.map((item) {
      final images = item['album']['images'] as List;
      return SpotifyTrack(
        title: item['name'] ?? '',
        artist: (item['artists'] as List).isNotEmpty
            ? item['artists'][0]['name']
            : '',
        imageUrl: images.isNotEmpty ? images[0]['url'] : '',
        spotifyUrl: item['external_urls']['spotify'] ?? '',
      );
    }).toList();
  }
}