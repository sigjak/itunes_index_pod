// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:xml/xml.dart';
import '../models/itunes_search_by_name.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// sennilega betra (of stórar myndir!!!!) að nota podcastindex.org þr sem description er að finna.
//String baseUrl = 'https://itunes.apple.com/search?term=fresh+air&entity=podcast&country=us&limit=20';

class SearchByName with ChangeNotifier {
  List<PodResult> searches = [];
  Future<void> nameSearch(String searchTerm) async {
    String url =
        'https://itunes.apple.com/search?term=$searchTerm&entity=podcast&country=us&limit=25';
    var result = await http.get(Uri.parse(url));
    if (result.statusCode == 200) {
      var decoded = json.decode(result.body);
      var data = Podcasts.fromJson(decoded);

      searches = [...data.results!];
      notifyListeners();
    }
  }

  Future<String> getDescription(feedUrl) async {
    //print('calling');
    String description = 'No data available';
    var xmlResult = await http.get(Uri.parse(feedUrl));
    if (xmlResult.statusCode == 200) {
      try {
        XmlDocument raw = XmlDocument.parse(xmlResult.body);
        var dat = raw.findAllElements('channel');
        description = dat.first.findElements('description').first.text;
      } catch (e) {
        print(e.toString());
      }
    } else {
      description = 'No description';
    }
    return description;
  }
}
