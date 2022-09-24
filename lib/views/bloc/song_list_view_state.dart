part of 'song_list_view_bloc.dart';

enum SongListStatus {
  initial,
  loading,
  loaded,
  error,
}

// enum ConnectivityStatus { initial, none, wifi, mobile, notFound }

// ignore: must_be_immutable
class SongListViewState extends Equatable {
  final SongListStatus listStatus;
  final List<Artist> artistResult;
  ConnectivityResult? connectivityResult = ConnectivityResult.none;
  final bool isDatabaseOpen;
  SongListViewState({
    required this.listStatus,
    required this.artistResult,
    this.connectivityResult,
    required this.isDatabaseOpen,
  });

  factory SongListViewState.initial() {
    return SongListViewState(
        listStatus: SongListStatus.initial,
        artistResult: const [],
        connectivityResult: ConnectivityResult.none,
        isDatabaseOpen: false);
  }

  @override
  List<Object?> get props =>
      [listStatus, artistResult, connectivityResult, isDatabaseOpen];

  SongListViewState copyWith({
    SongListStatus? listStatus,
    List<Artist>? artistResult,
    ConnectivityResult? connectivityResult,
    bool? isDatabaseOpen,
  }) {
    return SongListViewState(
      listStatus: listStatus ?? this.listStatus,
      artistResult: artistResult ?? this.artistResult,
      connectivityResult: connectivityResult ?? this.connectivityResult,
      isDatabaseOpen: isDatabaseOpen ?? this.isDatabaseOpen,
    );
  }

  @override
  String toString() {
    return 'SongListViewState(listStatus: $listStatus, artistResult: $artistResult, connectivityResult: $connectivityResult, isDatabaseOpen: $isDatabaseOpen)';
  }
}
