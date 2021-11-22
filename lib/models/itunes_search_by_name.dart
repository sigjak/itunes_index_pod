// To parse this JSON data, do
//
//     final podcasts = podcastsFromJson(jsonString);

import 'dart:convert';

Podcasts podcastsFromJson(String str) => Podcasts.fromJson(json.decode(str));

String podcastsToJson(Podcasts data) => json.encode(data.toJson());

//https://itunes.apple.com/search?term=fresh+air&entity=podcast&country=us&limit=20
class Podcasts {
  Podcasts({
    this.resultCount,
    this.results,
  });

  int? resultCount;
  List<PodResult>? results;

  factory Podcasts.fromJson(Map<String, dynamic> json) => Podcasts(
        resultCount: json["resultCount"],
        results: List<PodResult>.from(
            json["results"].map((x) => PodResult.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resultCount": resultCount,
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class PodResult {
  PodResult(
      {this.wrapperType,
      this.kind,
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
      this.currency,
      this.artworkUrl600,
      this.description = '',
      this.isExpanded = false});

  String? wrapperType;
  String? kind;
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
  int? trackCount;
  String? country;
  String? currency;
  String? artworkUrl600;
  String description = '';
  bool isExpanded = false;

  factory PodResult.fromJson(Map<String, dynamic> json) => PodResult(
        wrapperType: json["wrapperType"],
        kind: json["kind"],
        artistId: json["artistId"],
        collectionId: json["collectionId"],
        trackId: json["trackId"],
        artistName: json["artistName"],
        collectionName: json["collectionName"],
        trackName: json["trackName"],
        artistViewUrl: json["artistViewUrl"],
        collectionViewUrl: json["collectionViewUrl"],
        feedUrl: json["feedUrl"],
        trackViewUrl: json["trackViewUrl"],
        artworkUrl30: json["artworkUrl30"],
        artworkUrl60: json["artworkUrl60"],
        artworkUrl100: json["artworkUrl100"],
        trackCount: json["trackCount"],
        country: json["country"],
        currency: json["currency"],
        artworkUrl600: json["artworkUrl600"],
      );

  Map<String, dynamic> toJson() => {
        "wrapperType": wrapperType,
        "kind": kind,
        "artistId": artistId,
        "collectionId": collectionId,
        "trackId": trackId,
        "artistName": artistName,
        "collectionName": collectionName,
        "trackName": trackName,
        "artistViewUrl": artistViewUrl,
        "collectionViewUrl": collectionViewUrl,
        "feedUrl": feedUrl,
        "trackViewUrl": trackViewUrl,
        "artworkUrl30": artworkUrl30,
        "artworkUrl60": artworkUrl60,
        "artworkUrl100": artworkUrl100,
        "releaseDate": releaseDate!.toIso8601String(),
        "trackCount": trackCount,
        "country": country,
        "currency": currency,
        "artworkUrl600": artworkUrl600,
      };
}
