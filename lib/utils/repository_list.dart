import 'package:cj_itunes_artist/data/repositories/artist_repository.dart';

import 'package:cj_itunes_artist/data/services/artist_api_services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

List<RepositoryProvider> repositoryList(BuildContext context) {
  return [
    RepositoryProvider<ArtistRepository>(
      create: (BuildContext context) => ArtistRepository(
        artistApiServices: ArtistApiServices(
          httpClient: http.Client(),
        ),
      ),
    ),
  ];
}
