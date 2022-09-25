import 'dart:async';

import 'package:cj_itunes_artist/data/db/artist_db_helper.dart';
import 'package:cj_itunes_artist/utils/utils.dart';
import 'package:cj_itunes_artist/utils/widget_key.dart';
import 'package:cj_itunes_artist/views/bloc/song_list_view_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class SongListView extends StatefulWidget {
  const SongListView({Key? key}) : super(key: key);

  @override
  State<SongListView> createState() => _SongListViewState();
}

class _SongListViewState extends State<SongListView> {
  SongListViewBloc? _songListViewBloc;
  final TextEditingController _artistNameController = TextEditingController();
  late DatabaseHandler _handler;
  bool? _isDatabaseOpen;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    _handler = DatabaseHandler();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _songListViewBloc = BlocProvider.of<SongListViewBloc>(context);
    _isDatabaseOpen = _songListViewBloc!.state.isDatabaseOpen;

    if (!_isDatabaseOpen!) {
      _handler.initializeDB().whenComplete(() async {
        _songListViewBloc!.add(LocalDatabaseInitial());
      });
    }
    _initConnectivity(_connectivity, mounted);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: () async {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('The System Back Button is Deactivated'),
              ),
            );
            return false;
          },
          child: Padding(
            padding: EdgeInsets.only(top: 2.h, left: 1.5.w, right: 1.5.w),
            child: Column(
              children: [
                TextField(
                  key: const Key(WidgetKey.searchField),
                  controller: _artistNameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search songs by artist name'),
                  onSubmitted: (text) async {
                    if (text != '') {
                      _songListViewBloc!
                          .add(SearchButtonPressed(artistName: text));
                    }
                  },
                ),
                SizedBox(height: Utils.size(context, 2.h, 2.h, 2.h)),
                BlocBuilder<SongListViewBloc, SongListViewState>(
                  builder: (context, state) {
                    if (state.listStatus == SongListStatus.loading) {
                      return Row(
                        key: const Key(WidgetKey.loadingImage),
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: Utils.size(context, 10.h, 10.h, 10.h)),
                          Image.asset(
                            'assets/images/spinner.gif',
                            scale: 3,
                          ),
                        ],
                      );
                    }

                    if (state.listStatus == SongListStatus.loaded &&
                        state.artistResult.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(
                              height: Utils.size(context, 30.h, 30.h, 30.h)),
                          const Text('Your search did not match any documents',
                              key: Key('emptyListMessage')),
                        ],
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.artistResult.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 15.h,
                              key: const Key(WidgetKey.card),
                              child: Column(
                                children: [
                                  SizedBox(
                                      height: Utils.size(
                                          context, 1.h, 1.5.h, 1.5.h)),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: Utils.size(
                                              context, 1.h, 1.h, 1.h)),
                                      _showArtwork(
                                          state.artistResult[index]
                                              .artworkUrl100,
                                          state.connectivityResult!),
                                      SizedBox(
                                          width: Utils.size(
                                              context, 2.w, 2.w, 2.w)),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _showTrackName(state
                                                    .artistResult[index]
                                                    .trackName),
                                                Container(),
                                              ],
                                            ),
                                            SizedBox(
                                                height: Utils.size(
                                                    context, 1.h, 1.h, 1.h)),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _showTrackTime(state
                                                    .artistResult[index]
                                                    .trackTime),
                                                Container(),
                                              ],
                                            ),
                                            SizedBox(
                                                height: Utils.size(
                                                    context, 1.h, 1.h, 1.h)),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _showArtistName(state
                                                    .artistResult[index]
                                                    .artistName),
                                                Container(),
                                              ],
                                            ),
                                            SizedBox(
                                                height: Utils.size(
                                                    context, 0.3.h, 1.h, 1.h)),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                _showReleaseDate(state
                                                    .artistResult[index]
                                                    .releaseDate),
                                                _showCollectionPrice(state
                                                    .artistResult[index]
                                                    .collectionPrice)
                                              ],
                                            ),
                                            SizedBox(
                                                height: Utils.size(
                                                    context, 0.5.h, 1.h, 1.h)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                          width: Utils.size(
                                              context, 3.w, 2.w, 2.w)),
                                    ],
                                  ),
                                  SizedBox(
                                      height: Utils.size(
                                          context, 1.h, 1.5.h, 1.5.h)),
                                ],
                              ),
                            );
                          }),
                    );
                  },
                ),
                // SizedBox(height: Utils.size(context, 2.h, 2.h, 2.h)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _showArtwork(String artwork, ConnectivityResult connectivityStatus) {
    return connectivityStatus != ConnectivityResult.none
        ? SizedBox(
            width: Utils.size(context, 20.w, 20.w, 20.w),
            height: Utils.size(context, 30.w, 20.w, 20.w),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/spinner.gif',
              image: artwork,
              placeholderFit: BoxFit.none,
              fit: BoxFit.cover,
              placeholderScale: 2,
            ),
          )
        : SizedBox(
            width: Utils.size(context, 20.w, 20.w, 20.w),
            height: Utils.size(context, 30.w, 20.w, 20.w),
            child: Image.asset('assets/images/nointernet.png'),
          );
  }

  Widget _showTrackName(String trackName) {
    return SizedBox(
      width: Utils.size(context, 67.w, 56.w, 56.w),
      height: Utils.size(context, 5.h, 50.w, 50.w),
      child: Text(
        trackName,
        maxLines: 2,
        // overflow: TextOverflow.ellipsis,
        style: TextStyle(
            letterSpacing: 0.5,
            fontSize: Utils.size(context, 2.h, 3.h, 3.h),
            fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _showTrackTime(int trackTime) {
    int minutes = (trackTime ~/ 60000);
    String seconds = (((trackTime / 60000) - minutes) * 60).toStringAsFixed(0);
    return SizedBox(
      child: Text('${minutes.toString()}m${seconds}s',
          style: TextStyle(
              fontSize: Utils.size(context, 2.h, 2.h, 2.h),
              fontWeight: FontWeight.w700)),
    );
  }

  Widget _showArtistName(String artistName) {
    return SizedBox(
      width: Utils.size(context, 67.w, 50.w, 50.w),
      height: Utils.size(context, 4.h, 50.w, 50.w),
      child: Text(
        artistName.toUpperCase(),
        maxLines: 2,
        // overflow: TextOverflow.ellipsis,
        style: TextStyle(
            letterSpacing: 0.3,
            color: Colors.black54,
            fontSize: Utils.size(context, 1.8.h, 3.h, 3.h),
            fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _showReleaseDate(String releaseDate) {
    DateFormat inputFormat = DateFormat('yyyy-MM-dd');
    releaseDate = releaseDate.substring(0, releaseDate.indexOf('T'));
    var date1 = inputFormat.parse(releaseDate);
    // DateFormat outputFormat = DateFormat('MMMM d, yyyy');
    // String date2 = outputFormat.format(date1);
    return Text('(${date1.year.toString()})',
        style: TextStyle(
            fontSize: Utils.size(context, 1.8.h, 3.h, 3.h),
            fontWeight: FontWeight.w700));
  }

  Widget _showCollectionPrice(double collectionPrice) {
    return Text('\$${collectionPrice.toString()}',
        style: TextStyle(
            fontSize: Utils.size(context, 1.8.h, 3.h, 3.h),
            fontWeight: FontWeight.w700));
  }

  // Future<List<Artist>?> _getList() async {
  //   return await _handler.readSongs();
  // }

  // Future<void> initConnectivity() async {
  //   late ConnectivityResult result;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on PlatformException catch (e) {
  //     developer.log('Couldn\'t check connectivity status', error: e);
  //     return;
  //   }
  //   if (!mounted) {
  //     return Future.value(null);
  //   }

  //   return _updateConnectionStatus(result);
  // }

  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   setState(() {
  //     _connectionStatus = result;
  //   });
  //   _songListViewBloc!.add(ConnectivityStatusSet(result: _connectionStatus));
  // }

  Future<void> _updateConnectionStatus(ConnectivityResult? result) async {
    setState(() {
      _connectionStatus = result!;
    });
    _songListViewBloc!.add(ConnectivityStatusSet(result: _connectionStatus));
  }

  Future<void> _initConnectivity(Connectivity con, bool mounted) async {
    _songListViewBloc!
        .add(ConnectivityInitial(connectivity: con, mounted: mounted));
    _updateConnectionStatus(_songListViewBloc?.state.connectivityResult);
  }
}
