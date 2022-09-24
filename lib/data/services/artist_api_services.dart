import 'dart:convert';

import 'package:cj_itunes_artist/data/models/artist.dart';
import 'package:http/http.dart' as http;

class ArtistApiServices {
  final http.Client httpClient;
  ArtistApiServices({
    required this.httpClient,
  });

  Future<List<Artist>?> getSongsDetails(String artistName) async {
    final Uri uri = Uri(
      scheme: 'https',
      host: 'itunes.apple.com',
      path: '/search',
      queryParameters: {
        'term': artistName,
      },
    );

    try {
      final http.Response response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode != 200) {
        throw Exception('response.statusCode != 200');
      }

      final newsJson = json.decode(utf8.decode(response.bodyBytes))['results'];
      List<Artist> results =
          (newsJson as List).map((e) => Artist.fromJson(e)).toList();

      return results;
    } catch (e) {
      rethrow;
    }
  }
}
