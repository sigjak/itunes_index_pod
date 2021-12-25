import '../models/podIndex_itunes_epis.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../providers/podindex.dart';

class ItunesPindexEpisodeProvider with ChangeNotifier {
  List<Item> items = [];
  // String podcastName = '';
  // String podcastImage = '';

  Future<void> getEpisodes(int itunesID) async {
    var baseUrl =
        'https://api.podcastindex.org/api/1.0/episodes/byitunesid?max=20&id=';
    var url = Uri.parse(baseUrl + itunesID.toString());
    var headers = prepHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var episodes = itunesPodEpisodesFromJson(response.body);
      items = episodes.items!;

      notifyListeners();

      // print(items[0].title);
      // print(items[0].datePublished);
      // print(items[0].datePublishedPretty);
      // print(items[0].duration);
      // print(items[0].feedImage);

      // print(Duration(seconds: items[0].duration!));
    } else {
      print('Error');
    }
  }
}
