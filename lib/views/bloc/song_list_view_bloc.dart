import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cj_itunes_artist/data/db/artist_db_helper.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

import 'package:cj_itunes_artist/data/models/artist.dart';
import 'package:cj_itunes_artist/data/repositories/artist_repository.dart';

part 'song_list_view_event.dart';
part 'song_list_view_state.dart';

class SongListViewBloc extends Bloc<SongListViewEvent, SongListViewState> {
  final ArtistRepository artistRepository;

  SongListViewBloc({
    required this.artistRepository,
  }) : super(SongListViewState.initial()) {
    on<SearchButtonPressed>(_fetchSongResults);
    on<ConnectivityStatusSet>(_connectivityStatus);
    on<LocalDatabaseInitial>(_databaseInitial);
    on<ConnectivityInitial>(_connectivityInitial);
  }

  Future<void> _connectivityInitial(
      ConnectivityInitial event, Emitter<SongListViewState> emit) async {
    ConnectivityResult? cr = await artistRepository.initConnectivity(
        event.connectivity, event.mounted);
    add(ConnectivityStatusSet(result: cr!));
  }

  Future<void> _fetchSongResults(
      SearchButtonPressed event, Emitter<SongListViewState> emit) async {
    try {
      if (state.connectivityResult != ConnectivityResult.none) {
        String name = event.artistName.replaceAll(' ', '+');
        emit(state.copyWith(listStatus: SongListStatus.loading));
        List<Artist>? songResults = await artistRepository.readSongList(name);
        emit(state.copyWith(
            listStatus: SongListStatus.loaded, artistResult: songResults));

        if (songResults != null || songResults!.isNotEmpty) {
          await DatabaseHandler().insertSongs(songResults);
        }
      } else {
        emit(state.copyWith(listStatus: SongListStatus.loading));
        List<Artist>? songResults =
            await DatabaseHandler().querySongs(event.artistName);
        emit(state.copyWith(
            listStatus: SongListStatus.loaded, artistResult: songResults));
      }
    } catch (e) {
      emit(state.copyWith(listStatus: SongListStatus.error));
    }
  }

  void _connectivityStatus(
      ConnectivityStatusSet event, Emitter<SongListViewState> emit) {
    emit(state.copyWith(connectivityResult: event.result));

    log(event.result.toString());
  }

  Future<void> _databaseInitial(
      LocalDatabaseInitial event, Emitter<SongListViewState> emit) async {
    await DatabaseHandler().readSongs();
    emit(state.copyWith(isDatabaseOpen: true));
  }
}
