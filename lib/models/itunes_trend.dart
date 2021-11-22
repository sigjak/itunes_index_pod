// To parse this JSON data, do
//
//     final itunesTrend = itunesTrendFromJson(jsonString);

import 'dart:convert';

ItunesTrend itunesTrendFromJson(String str) =>
    ItunesTrend.fromJson(json.decode(str));

String itunesTrendToJson(ItunesTrend data) => json.encode(data.toJson());

class ItunesTrend {
  ItunesTrend({
    this.resultCount,
    this.results,
  });

  int? resultCount;
  List<Result>? results;

  factory ItunesTrend.fromJson(Map<String, dynamic> json) => ItunesTrend(
        resultCount: json["resultCount"],
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resultCount": resultCount,
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.collectionId,
    this.trackId,
    this.artistName,
    this.collectionName,
    this.trackName,
    this.collectionViewUrl,
    this.feedUrl,
    this.trackViewUrl,
    this.artworkUrl30,
    this.artworkUrl60,
    this.artworkUrl100,
    this.releaseDate,
    this.trackCount,
    this.artworkUrl600,
    this.genreIds,
    this.genres,
    this.artistId,
    this.artistViewUrl,
    this.description = '',
  });

  int? collectionId;
  int? trackId;
  String? collectionName;
  String? trackName;

  String? collectionViewUrl;
  String? feedUrl;
  String? trackViewUrl;
  String? artworkUrl30;
  String? artworkUrl60;
  String? artworkUrl100;
  String? artistName;
  String description;
  DateTime? releaseDate;

  int? trackCount;

  String? primaryGenreName;

  String? artworkUrl600;
  List<String>? genreIds;
  List<String>? genres;
  int? artistId;
  String? artistViewUrl;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        // wrapperType: wrapperTypeValues.map[json["wrapperType"]],
        // kind: kindValues.map[json["kind"]],
        collectionId: json["collectionId"],
        trackId: json["trackId"],
        artistName: json["artistName"],
        collectionName: json["collectionName"],
        trackName: json["trackName"],

        collectionViewUrl: json["collectionViewUrl"],
        feedUrl: json["feedUrl"],
        trackViewUrl: json["trackViewUrl"],
        artworkUrl30: json["artworkUrl30"],
        artworkUrl60: json["artworkUrl60"],
        artworkUrl100: json["artworkUrl100"],

        trackCount: json["trackCount"],

        //currency: currencyValues.map[json["currency"]],

        artistId: json["artistId"],
        artistViewUrl: json["artistViewUrl"],
      );

  Map<String, dynamic> toJson() => {
        "collectionId": collectionId,
        "trackId": trackId,
        "artistName": artistName,
        "collectionName": collectionName,
        "trackName": trackName,
        "collectionViewUrl": collectionViewUrl,
        "feedUrl": feedUrl,
        "trackViewUrl": trackViewUrl,
        "artworkUrl30": artworkUrl30,
        "artworkUrl60": artworkUrl60,
        "artworkUrl100": artworkUrl100,
        "releaseDate": releaseDate!.toIso8601String(),
        "trackCount": trackCount,
        "primaryGenreName": primaryGenreName,
        "artworkUrl600": artworkUrl600,
        "genreIds": List<dynamic>.from(genreIds!.map((x) => x)),
        "genres": List<dynamic>.from(genres!.map((x) => x)),
        "artistId": artistId ?? '',
        "artistViewUrl": artistViewUrl ?? '',
      };
}
