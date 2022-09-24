import 'package:cj_itunes_artist/data/db/artist_db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'package:cj_itunes_artist/utils/bloc_list.dart';
import 'package:cj_itunes_artist/utils/constants.dart';
import 'package:cj_itunes_artist/utils/repository_list.dart';
import 'package:cj_itunes_artist/views/song_list_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHandler().initializeDB();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiRepositoryProvider(
          providers: repositoryList(context),
          child: MultiBlocProvider(
            providers: blocList(context),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: Constants.themeData(),
              home: const SongListView(),
            ),
          ),
        );
      },
    );
  }
}
