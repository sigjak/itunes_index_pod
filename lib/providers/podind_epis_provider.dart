import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/episodes_by_itunesid.dart';
import 'podindex.dart';

class PodIndexEpisodeProvider with ChangeNotifier {
  List<Item> items = [];
  // String podcastName = '';
  // String podcastImage = '';

  Future<void> getEpisodes(int feedID) async {
    var baseUrl =
        'https://api.podcastindex.org/api/1.0/episodes/byitunesid?max=20&id=';
    var url = Uri.parse(baseUrl + feedID.toString());
    var headers = prepHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      var episodes = episodesByItunesIdFromJson(response.body);
      items = episodes.items!;

      notifyListeners();
      //print(items.length);
      // print(items[0].title);
    } else {
      print('Error');
    }
  }
}
