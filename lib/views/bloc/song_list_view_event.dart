part of 'song_list_view_bloc.dart';

abstract class SongListViewEvent extends Equatable {
  const SongListViewEvent();

  @override
  List<Object> get props => [];
}

class SearchButtonPressed extends SongListViewEvent {
  final String artistName;
  const SearchButtonPressed({
    required this.artistName,
  });
}

class ConnectivityStatusSet extends SongListViewEvent {
  final ConnectivityResult result;
  const ConnectivityStatusSet({
    required this.result,
  });
}

class LocalDatabaseInitial extends SongListViewEvent {}

class ConnectivityInitial extends SongListViewEvent {
  final Connectivity connectivity;
  final bool mounted;
  const ConnectivityInitial({
    required this.connectivity,
    required this.mounted,
  });
}

// class UpdateConnectionStatus  extends SongListViewEvent{

// }
