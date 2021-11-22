import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:itunes_pod/providers/podind_epis_provider.dart';
import 'package:itunes_pod/providers/search_provider.dart';
import 'package:itunes_pod/screens/audio_screen.dart';
import 'package:provider/provider.dart';
//import 'package:intl/intl.dart';
// import 'package:just_audio/just_audio.dart';
import '../models/itunes_trend.dart';
//import '../models/itunes_episodes.dart';
import '../providers/trend_provider.dart';
//import './audio_screen.dart';
//import '../providers/episode_provider.dart';

class TrendScreen extends StatefulWidget {
  const TrendScreen({Key? key}) : super(key: key);

  @override
  _TrendScreenState createState() => _TrendScreenState();
}

class _TrendScreenState extends State<TrendScreen> {
  List<Result> trendData = [];

  List<String> categoryList = [
    'Arts',
    'Books',
    'News',
    'Comedy',
    'Daily',
    'FilmReviews',
    'Food',
    'History',
    'Music',
    'Science',
    'Philosophy',
    'Politics',
    'True Crime',
    'TV&Film',
    'Society&Culture',
    'EarthSciences'
  ];
  List<String> categoryNumbers = [
    '1301',
    '1482',
    '1489',
    '1303',
    '1526',
    '1565',
    '1306',
    '1487',
    '1310',
    '1533',
    '1443',
    '1527',
    '1488',
    '1309',
    '1324',
    '1540'
  ];
  List<bool> selectionList = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  String trendName = '';
  String currentItunesId = '';
  String currentPodcastName = '';
  bool isLoading = true;
  int isSelected = 0;

  bool isFirstTime = true;
  bool isDescription = true;
  String description = '';

  late ScrollController _trendScrollController;
  @override
  void initState() {
    _trendScrollController = ScrollController();
    getTrendData('1301', 'Arts');
    super.initState();
  }

  getTrendData(String trendId, String name) {
    context.read<Trends>().getTrends(trendId).then((_) {
      setState(() {
        trendData = context.read<Trends>().trendList;
        isLoading = false;
        isSelected = 0;
        getDescription(trendData[0]);
        trendName = name;
      });
    });
  }

  static String stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  @override
  void dispose() {
    _trendScrollController.dispose();
    super.dispose();
  }

  Future<void> getDescription(trend) async {
    if (trend.description.isEmpty) {
      String descr =
          await context.read<SearchByName>().getDescription(trend.feedUrl);
      trend.description = stripHtmlIfNeeded(descr);
    }
    setState(() {
      description = trend.description;
      currentPodcastName = trend.collectionName!;
      currentItunesId = trend.collectionId.toString();
      isDescription = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Trending',
                    style: TextStyle(fontSize: 32, fontFamily: 'MonteCarlo'),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      toggleButtons(),
                    ],
                  ),
                ),
                Text(
                  trendName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView.builder(
                              controller: _trendScrollController,
                              scrollDirection: Axis.horizontal,
                              itemCount: trendData.length,
                              itemBuilder: (context, index) {
                                final trend = trendData[index];
                                return SizedBox(
                                  width: 100,
                                  child: GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        isDescription = false;
                                        isSelected = index;
                                        currentPodcastName =
                                            trend.collectionName!;
                                        currentItunesId =
                                            trend.collectionId.toString();
                                      });
                                      getDescription(trend);
                                      print(currentItunesId);
                                    },
                                    child: Card(
                                      child: Stack(children: [
                                        CachedNetworkImage(
                                          width: 100,
                                          imageUrl: trend.artworkUrl100!,
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  'assets/images/dd.png'),
                                        ),
                                        isSelected == index
                                            ? const Positioned(
                                                bottom: 5,
                                                right: 5,
                                                child: Icon(
                                                  Icons.check_circle_outline,
                                                  size: 50,
                                                  color: Colors.amberAccent,
                                                ))
                                            : const SizedBox()
                                      ]),
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ),
                Center(
                  child: isDescription
                      ? Container(
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(maxHeight: 175),
                          child: Card(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(12),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AudioScreen(
                                              itunesId: currentItunesId)));
                                },
                                child: ListTile(
                                  title: Text(
                                    currentPodcastName,
                                    textAlign: TextAlign.center,
                                  ),
                                  subtitle: Text(
                                    description,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : const CircularProgressIndicator(),
                ),
                ElevatedButton(
                    onPressed: () {
                      context
                          .read<PodIndexEpisodeProvider>()
                          .getEpisodes(201671138);
                    },
                    child: const Text('pre')),
              ],
            ),
    );
  }

  ToggleButtons toggleButtons() {
    return ToggleButtons(
      color: Colors.white,
      splashColor: Colors.white,
      selectedColor: Colors.white,
      selectedBorderColor: Colors.grey.shade300,
      children: categoryList
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(item),
              ))
          .toList(),
      isSelected: selectionList,
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0;
              buttonIndex < selectionList.length;
              buttonIndex++) {
            if (buttonIndex == index) {
              selectionList[buttonIndex] = true;
              getTrendData(
                  categoryNumbers[buttonIndex], categoryList[buttonIndex]);
              _trendScrollController.animateTo(0,
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOutCubic);
              //isEpisodes = false;
            } else {
              selectionList[buttonIndex] = false;
            }
          }
        });
      },
    );
  }
}
