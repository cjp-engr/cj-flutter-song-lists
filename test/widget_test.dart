import 'package:cj_itunes_artist/data/models/artist.dart';
import 'package:cj_itunes_artist/data/repositories/artist_repository.dart';
import 'package:cj_itunes_artist/utils/widget_key.dart';
import 'package:cj_itunes_artist/views/bloc/song_list_view_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cj_itunes_artist/main.dart' as app;
import 'package:http/http.dart' as http;

class MockSongListViewBloc extends Mock implements SongListViewBloc {}

class MockArtistRepository extends Mock implements ArtistRepository {}

class MockHttpClient extends Mock implements http.Client {}

final posts = List.generate(
  20,
  (index) => Artist(
      trackId: index,
      artistName: 'Nick Jonas',
      trackName: 'trackName ${index.toString()}',
      releaseDate: 'releaseDate ${index.toString()}',
      collectionPrice: index * 1000,
      artworkUrl100: 'artworkUrl100 ${index.toString()}',
      trackTime: index * 1000),
);

void main() {
  group('Song List View Test', () {
    late MockArtistRepository mockArtistRepository;
    late MockSongListViewBloc mockSongListViewBloc;
    setUp(() {
      mockArtistRepository = MockArtistRepository();
      mockSongListViewBloc = MockSongListViewBloc();
      // when(() => mockArtistRepository.readSongList('nick+jonas'))
      //     .thenAnswer((invocation) => Future.value(posts));
      when(() => mockArtistRepository.readSongList('nick jonas'))
          .thenAnswer((_) async => posts);
    });

    testWidgets('Song List state is initial', (tester) async {
      when(() => mockSongListViewBloc.state).thenReturn(SongListViewState(
          listStatus: SongListStatus.initial,
          isDatabaseOpen: false,
          artistResult: const []));
      await tester.pumpWidget(const app.MyApp());
      expect(mockSongListViewBloc.state.listStatus, SongListStatus.initial);
      expect(mockSongListViewBloc.state.artistResult.length, 0);
    });

    testWidgets('Song List View is loading', (tester) async {
      final Finder searchFormField =
          find.byKey(const Key(WidgetKey.searchField));
      when(() => mockSongListViewBloc.state).thenReturn(SongListViewState(
          listStatus: SongListStatus.loading,
          isDatabaseOpen: true,
          artistResult: const []));
      await tester.pumpWidget(const app.MyApp());

      await tester.enterText(searchFormField, 'Nick Jonas');
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(mockSongListViewBloc.state.listStatus, SongListStatus.loading);
      expect(mockSongListViewBloc.state.artistResult.length, 0);
    });

    testWidgets('Song List state is loaded with results', (tester) async {
      when(() => mockSongListViewBloc.state).thenReturn(SongListViewState(
          listStatus: SongListStatus.loaded,
          isDatabaseOpen: true,
          artistResult: posts));
      await tester.pumpWidget(const app.MyApp());
      final searchFormField = find.byKey(const Key(WidgetKey.searchField));
      await tester.enterText(searchFormField, 'Nick Jonas');
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expect(find.byKey(const Key(WidgetKey.card)), isNotNull);
      expect(mockSongListViewBloc.state.listStatus, SongListStatus.loaded);
      expect(mockSongListViewBloc.state.artistResult.length, isNonZero);
      expect(find.text('Nick Jonas'), findsOneWidget);
    });

    testWidgets('Song List state is loaded with no results', (tester) async {
      when(() => mockSongListViewBloc.state).thenReturn(SongListViewState(
          listStatus: SongListStatus.loaded,
          isDatabaseOpen: true,
          artistResult: const []));
      await tester.pumpWidget(const app.MyApp());
      final searchFormField = find.byKey(const Key(WidgetKey.searchField));
      await tester.enterText(searchFormField, 'jfgdljglfdjfgfdhkhfgeyiry');
      await tester.pumpAndSettle(const Duration(seconds: 1));
      expectLater(mockSongListViewBloc.state.listStatus, SongListStatus.loaded);
      expectLater(mockSongListViewBloc.state.artistResult.length, 0);
      // expectLater(
      //     find.text('Your search did not match any documents'), findsOneWidget);
    });

    testWidgets('Song List View displays an error', (tester) async {
      when(() => mockSongListViewBloc.state).thenReturn(SongListViewState(
        listStatus: SongListStatus.error,
        isDatabaseOpen: true,
        artistResult: const [],
      ));
      await tester.pumpWidget(const app.MyApp());
      expect(mockSongListViewBloc.state.listStatus, SongListStatus.error);
      expect(mockSongListViewBloc.state.artistResult.length, 0);
    });
  });
}
