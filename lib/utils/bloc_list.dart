import 'package:cj_itunes_artist/data/repositories/artist_repository.dart';
import 'package:cj_itunes_artist/views/bloc/song_list_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> blocList(BuildContext context) {
  return [
    BlocProvider<SongListViewBloc>(
      create: (BuildContext context) => SongListViewBloc(
        artistRepository: RepositoryProvider.of<ArtistRepository>(context),
      ),
    ),
  ];
}
