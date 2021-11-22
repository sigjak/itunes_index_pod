// To parse this JSON data, do
//
//     final episodes = episodesFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators
//https://itunes.apple.com/lookup?id=1251196416&country=US&media=podcast&entity=podcastEpisode&limit=100
import 'dart:convert';

Episodes episodesFromJson(String str) => Episodes.fromJson(json.decode(str));

String episodesToJson(Episodes data) => json.encode(data.toJson());

class Episodes {
  Episodes({
    this.resultCount,
    this.results,
  });

  int? resultCount;
  List<Episode>? results;

  factory Episodes.fromJson(Map<String, dynamic> json) => Episodes(
        resultCount: json["resultCount"],
        results:
            List<Episode>.from(json["results"].map((x) => Episode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resultCount": resultCount,
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Episode {
  Episode({
    this.artistId,
    this.collectionId,
    this.trackId,
    this.artistName,
    this.collectionName,
    this.trackName,
    this.artistViewUrl,
    this.collectionViewUrl,
    this.feedUrl,
    this.trackViewUrl,
    this.artworkUrl30,
    this.artworkUrl60,
    this.artworkUrl100,
    this.releaseDate,
    this.trackCount,
    this.country,
    this.primaryGenreName,
    this.artworkUrl600,
    this.genreIds,
    this.genres,
    this.episodeUrl,
    this.trackTimeMillis,
    this.previewUrl,
    this.artworkUrl160,
    this.episodeFileExtension,
    this.episodeContentType,
    this.artistIds,
    this.shortDescription,
    this.episodeGuid,
    this.description,
  });

  int? artistId;
  int? collectionId;
  int? trackId;
  String? artistName;
  String? collectionName;
  String? trackName;

  String? artistViewUrl;
  String? collectionViewUrl;
  String? feedUrl;
  String? trackViewUrl;
  String? artworkUrl30;
  String? artworkUrl60;
  String? artworkUrl100;

  DateTime? releaseDate;
  String? collectionExplicitness;

  int? trackCount;
  String? country;

  String? primaryGenreName;
  String? artworkUrl600;
  List<String>? genreIds;
  List<dynamic>? genres;
  String? episodeUrl;
  int? trackTimeMillis;
  String? previewUrl;
  String? artworkUrl160;
  String? episodeFileExtension;
  String? episodeContentType;

  List<int>? artistIds;

  String? shortDescription;
  String? episodeGuid;
  String? description;

  factory Episode.fromJson(Map<String, dynamic> json) => Episode(
        artistId: json["artistId"],
        collectionId: json["collectionId"],
        trackId: json["trackId"],
        artistName: json["artistName"] ?? '',
        collectionName: json["collectionName"],
        trackName: json["trackName"],
        artistViewUrl: json["artistViewUrl"],
        collectionViewUrl: json["collectionViewUrl"],
        feedUrl: json["feedUrl"],
        trackViewUrl: json["trackViewUrl"],
        artworkUrl30: json["artworkUrl30"] ?? '',
        artworkUrl60: json["artworkUrl60"],
        artworkUrl100: json['atworkUrl1100'],
        trackCount: json["trackCount"],
        releaseDate: DateTime.parse(json["releaseDate"]),
        country: json["country"],
        primaryGenreName:
            json["primaryGenreName"] == null ? null : json["primaryGenreName"],
        artworkUrl600: json["artworkUrl600"],
        genreIds: json["genreIds"] == null
            ? null
            : List<String>.from(json["genreIds"].map((x) => x)),
        genres: List<dynamic>.from(json["genres"].map((x) => x)),
        episodeUrl: json["episodeUrl"] == null ? null : json["episodeUrl"],
        trackTimeMillis:
            json["trackTimeMillis"] == null ? null : json["trackTimeMillis"],
        previewUrl: json["previewUrl"] == null ? null : json["previewUrl"],
        artworkUrl160:
            json["artworkUrl160"] == null ? null : json["artworkUrl160"],
        episodeFileExtension: json["episodeFileExtension"] == null
            ? null
            : json["episodeFileExtension"],
        episodeContentType: json["episodeContentType"] == null
            ? null
            : json["episodeContentType"],
        artistIds: json["artistIds"] == null
            ? null
            : List<int>.from(json["artistIds"].map((x) => x)),
        shortDescription:
            json["shortDescription"] == null ? null : json["shortDescription"],
        episodeGuid: json["episodeGuid"] == null ? null : json["episodeGuid"],
        description: json["description"] == null ? null : json["description"],
      );

  Map<String, dynamic> toJson() => {
        "artistId": artistId == null ? null : artistId,
        "collectionId": collectionId,
        "trackId": trackId,
        "artistName": artistName == null ? null : artistName,
        "collectionName": collectionName,
        "trackName": trackName,
        "artistViewUrl": artistViewUrl,
        "collectionViewUrl": collectionViewUrl,
        "feedUrl": feedUrl,
        "trackViewUrl": trackViewUrl,
        "artworkUrl30": artworkUrl30 == null ? null : artworkUrl30,
        "artworkUrl60": artworkUrl60,
        "artworkUrl100": artworkUrl100 == null ? null : artworkUrl100,
        "releaseDate": releaseDate!.toIso8601String(),
        "collectionExplicitness":
            collectionExplicitness == null ? null : collectionExplicitness,
        "trackCount": trackCount == null ? null : trackCount,
        "country": country,
        "primaryGenreName": primaryGenreName == null ? null : primaryGenreName,
        "artworkUrl600": artworkUrl600,
        "genreIds": genreIds == null
            ? null
            : List<dynamic>.from(genreIds!.map((x) => x)),
        "genres": List<dynamic>.from(genres!.map((x) => x)),
        "episodeUrl": episodeUrl == null ? null : episodeUrl,
        "trackTimeMillis": trackTimeMillis == null ? null : trackTimeMillis,
        "previewUrl": previewUrl == null ? null : previewUrl,
        "artworkUrl160": artworkUrl160 == null ? null : artworkUrl160,
        "episodeFileExtension":
            episodeFileExtension == null ? null : episodeFileExtension,
        "episodeContentType":
            episodeContentType == null ? null : episodeContentType,
        "artistIds": artistIds == null
            ? null
            : List<dynamic>.from(artistIds!.map((x) => x)),
        "shortDescription": shortDescription == null ? null : shortDescription,
        "episodeGuid": episodeGuid == null ? null : episodeGuid,
        "description": description == null ? null : description,
      };
}

class GenreClass {
  GenreClass({
    this.name,
    this.id,
  });

  String? name;
  String? id;

  factory GenreClass.fromJson(Map<String, dynamic> json) => GenreClass(
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
