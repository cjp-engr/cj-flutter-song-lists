import 'dart:developer';

import 'package:cj_itunes_artist/data/models/artist.dart';
import 'package:cj_itunes_artist/data/services/artist_api_services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

class ArtistRepository {
  final ArtistApiServices artistApiServices;

  ArtistRepository({required this.artistApiServices});

  Future<List<Artist>?> readSongList(String artistName) async {
    try {
      List<Artist>? songList =
          await artistApiServices.getSongsDetails(artistName);
      return songList;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<ConnectivityResult?> initConnectivity(
      Connectivity connectivity, bool mounted) async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return null;
    }
    if (!mounted) {
      return Future.value(null);
    }

    return result;
  }
}
