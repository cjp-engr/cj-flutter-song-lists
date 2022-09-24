import 'dart:developer';

import 'package:cj_itunes_artist/data/models/artist.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'adatabase.db'),
      onCreate: (database, version) async {
        database.execute(
          '''CREATE TABLE a(trackId INTEGER PRIMARY KEY, 
                                  artistName TEXT, 
                                  trackName TEXT,
                                  releaseDate TEXT,
                                  collectionPrice REAL,
                                  artworkUrl100 TEXT,
                                  trackTime INTEGER)''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertSongs(List<Artist> songs) async {
    final db = await initializeDB();
    Batch batch = db.batch();
    for (var i = 0; i < songs.length; i++) {
      batch.insert('a', songs[i].toMap());
    }

    await batch.commit();
  }

  Future<List<Artist>?> readSongs() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('a');
    log(queryResult.map((e) => Artist.fromJson(e)).toList().length.toString());
    return queryResult.map((e) => Artist.fromJson(e)).toList();
  }

  Future<List<Artist>?> querySongs(String artistName) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db
        .query('a', where: "artistName LIKE ?", whereArgs: ['%$artistName%']);
    log(queryResult.map((e) => Artist.fromJson(e)).toList().length.toString());
    return queryResult.map((e) => Artist.fromJson(e)).toList();
  }

  // Future<void> deleteSongs(int id) async {
  //   // Get a reference to the database.
  //   final db = await initializeDB();

  //   // Remove the Dog from the database.
  //   await db.delete(
  //     'a',
  //     // Use a `where` clause to delete a specific dog.
  //     where: 'id = ?',
  //     // Pass the Dog's id as a whereArg to prevent SQL injection.
  //     whereArgs: [id],
  //   );
  // }
}
