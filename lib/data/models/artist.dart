import 'package:equatable/equatable.dart';

class Artist extends Equatable {
  final int trackId;
  final String artistName;
  final String trackName;
  final String releaseDate;
  final double collectionPrice;
  final String artworkUrl100;
  final int trackTime;
  const Artist({
    required this.trackId,
    required this.artistName,
    required this.trackName,
    required this.releaseDate,
    required this.collectionPrice,
    required this.artworkUrl100,
    required this.trackTime,
  });

  Artist.fromJson(Map<String, dynamic> json)
      : trackId = json['trackId'] ?? 000,
        artistName = json['artistName'] ?? 'No Artist Name',
        trackName = json['trackName'] ?? 'No Track Name',
        releaseDate = json['releaseDate'] ?? 'No Release Date',
        collectionPrice = json['collectionPrice'] ?? 0.00,
        artworkUrl100 = json['artworkUrl100'] ?? 'No Artwork',
        trackTime = json['trackTimeMillis'] ?? 0;

  Map<String, dynamic> toMap() {
    return {
      'trackId': trackId,
      'artistName': artistName,
      'trackName': trackName,
      'releaseDate': releaseDate,
      'collectionPrice': collectionPrice,
      'artworkUrl100': artworkUrl100,
      'trackTime': trackTime
    };
  }

  @override
  List<Object?> get props => [
        trackId,
        artistName,
        trackName,
        releaseDate,
        collectionPrice,
        artworkUrl100,
        trackTime,
      ];
}
