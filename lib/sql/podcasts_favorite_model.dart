// ignore_for_file: prefer_adjacent_string_concatenation

const String favoritePodcastsTable = 'favoritePodcastsTable';

class PodcastFavFields {
  static const String podcastName = 'podcastName';
  static const String podcastImage = 'podcastImage';
  static const String podcastFeed = 'podcastFeed';

  static final List<String> allFields = [
    podcastName,
    podcastImage,
    podcastFeed
  ];
}

class PodFavorite {
  String podcastName;
  String podcastImage;
  int podcastFeed;

  PodFavorite({
    required this.podcastName,
    required this.podcastImage,
    required this.podcastFeed,
  });

  Map<String, dynamic> toJson() => {
        PodcastFavFields.podcastName: podcastName,
        PodcastFavFields.podcastImage: podcastImage,
        PodcastFavFields.podcastFeed: podcastFeed,
      };

  static PodFavorite fromJson(Map<String, dynamic> json) => PodFavorite(
        podcastName: json[PodcastFavFields.podcastName] as String,
        podcastImage: json[PodcastFavFields.podcastImage] as String,
        podcastFeed: json[PodcastFavFields.podcastFeed] as int,
      );

  @override

  // ignore: avoid_renaming_method_parameters
  bool operator ==(covariant PodFavorite favorite) {
    return (podcastName == favorite.podcastName);
  }

  @override
  int get hashCode {
    return podcastName.hashCode;
  }

  @override
  String toString() {
    return '${PodcastFavFields.podcastName}: $podcastName\n' +
        '${PodcastFavFields.podcastImage}: $podcastImage\n' +
        '${PodcastFavFields.podcastFeed}: $podcastFeed\n';
  }
}
