//  search PODCASTINDEX.ORG BY ItuNES ID
// To parse this JSON data, do
//
//     final episodesByItunesId = episodesByItunesIdFromJson(jsonString?);

import 'dart:convert';

EpisodesByItunesId episodesByItunesIdFromJson(String str) =>
    EpisodesByItunesId.fromJson(json.decode(str));

String episodesByItunesIdToJson(EpisodesByItunesId data) =>
    json.encode(data.toJson());

class EpisodesByItunesId {
  EpisodesByItunesId({
    this.status,
    this.items,
    this.count,
    this.query,
    this.description,
  });

  String? status;
  List<Item>? items;
  int? count;
  String? query;
  String? description;

  factory EpisodesByItunesId.fromJson(Map<String, dynamic> json) =>
      EpisodesByItunesId(
        status: json["status"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        count: json["count"],
        query: json["query"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
        "count": count,
        "query": query,
        "description": description,
      };
}

class Item {
  Item({
    this.id,
    this.title,
    this.link,
    this.description,
    this.guid,
    this.datePublished,
    this.datePublishedPretty,
    this.enclosureUrl,
    this.enclosureLength,
    this.duration,
    this.episode,
    this.season,
    this.image,
    this.feedItunesId,
    this.feedImage,
    this.feedId,
    this.chaptersUrl,
  });

  int? id;
  String? title;
  String? link;
  String? description;
  String? guid;
  int? datePublished;
  String? datePublishedPretty;
  int? dateCrawled;
  String? enclosureUrl;

  int? enclosureLength;
  int? duration;
  int? explicit;
  int? episode;
  String? episodeType;
  int? season;
  String? image;
  int? feedItunesId;
  String? feedImage;
  int? feedId;

  String? chaptersUrl;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        title: json["title"],
        link: json["link"],
        description: json["description"],
        guid: json["guid"],
        datePublished: json["datePublished"],
        datePublishedPretty: json["datePublishedPretty"],
        enclosureUrl: json["enclosureUrl"],
        enclosureLength: json["enclosureLength"],
        duration: json["duration"],
        episode: json["episode"],
        season: json["season"],
        image: json["image"],
        feedItunesId: json["feedItunesId"],
        feedImage: json["feedImage"],
        feedId: json["feedId"],
        chaptersUrl: json["chaptersUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "link": link,
        "description": description,
        "guid": guid,
        "datePublished": datePublished,
        "datePublishedPretty": datePublishedPretty,
        "dateCrawled": dateCrawled,
        "enclosureUrl": enclosureUrl,
        "enclosureLength": enclosureLength,
        "duration": duration,
        "explicit": explicit,
        "episode": episode,
        "episodeType": episodeType,
        "season": season,
        "image": image,
        "feedItunesId": feedItunesId,
        "feedImage": feedImage,
        "feedId": feedId,
        "chaptersUrl": chaptersUrl,
      };
}

class Soundbite {
  Soundbite({
    this.startTime,
    this.duration,
    this.title,
  });

  int? startTime;
  int? duration;
  String? title;

  factory Soundbite.fromJson(Map<String, dynamic> json) => Soundbite(
        startTime: json["startTime"],
        duration: json["duration"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "startTime": startTime,
        "duration": duration,
        "title": title,
      };
}
