import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:itunes_pod/sql/episode_favorite_model.dart';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../services/position_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../sql/podcast_sql_services.dart';
import '../models/itunes_episodes.dart';
import '../audio/player_buttons.dart';
import '../audio/slider_bar.dart';

class PlaySaved extends StatefulWidget {
  const PlaySaved({required this.itunesId, required this.podcastName, Key? key})
      : super(key: key);
  final String itunesId;
  final String podcastName;

  @override
  _PlaySavedState createState() => _PlaySavedState();
}

class _PlaySavedState extends State<PlaySaved> with WidgetsBindingObserver {
  List<Episode> episodes = [];
  List<EpisFavorite> savedEpisodes = [];
  AudioPlayer player = AudioPlayer();
  bool isLoaded = false;
  bool isSelected = false;
  // bool isFavorite = false;
  int? tappedIndex;
  String episodeName = '';

  late String podcastImage;
  late int itunesPodcastId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);

    getSavedData();

    //setState(() {});

    super.initState();
  }

  List<Episode> transPose() {
    List<Episode> tempEp = [];
    for (int i = 0; i < savedEpisodes.length; i++) {
      Episode episode = Episode(
        collectionName: savedEpisodes[i].podcastName,
        episodeUrl: savedEpisodes[i].dloadLocation,
        artworkUrl600: savedEpisodes[i].podcastImage,
        trackName: savedEpisodes[i].episodeName,
        description: savedEpisodes[i].episodeDescription,
        trackTimeMillis: savedEpisodes[i].episodeDuration,
        releaseDate: DateTime.parse(savedEpisodes[i].episodeDate),
      );
      tempEp.add(episode);
    }
    Episode episodeZero = Episode(
        collectionName: savedEpisodes[0].podcastName,
        artworkUrl600: savedEpisodes[0].podcastImage);
    tempEp.insert(0, episodeZero);

    return tempEp;
  }

  Future<void> getSavedData() async {
    var podservice = context.read<PodcastServices>();
    await podservice.getEpisodesFromSinglePodcast(widget.podcastName);
    setState(() {
      savedEpisodes = [...podservice.favSinglePodEpisodes];
      episodes = transPose();
      podcastImage = episodes[0].artworkUrl600!;
      isLoaded = true;
    });
  }

  Future<void> _init(Episode episode) async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(snack(Icons.error, 'Stream error!'));
    });

    try {
      AudioSource audioSource = AudioSource.uri(Uri.parse(episode.episodeUrl!),
          tag: MediaItem(
              id: '1',
              album: episode.collectionName,
              title: episode.trackName!));
      await player.setAudioSource(audioSource);
      Duration seeking = await posService.getSavedPosition(episodeName);

      player.seek(seeking);
      player.play();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        snack(Icons.error, 'Error loading audio'),
      );
    }
  }

  SnackBar snack(IconData messIcon, String errorText) {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            messIcon,
            size: 50,
            color: Colors.red,
          ),
          Text(
            errorText,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _scrollController.dispose();
    player.dispose();
    super.dispose();
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
  String dateToString(DateTime dt) {
    DateFormat dateFormat = DateFormat('dd-MMM-yyyy');
    return 'Release date: ${dateFormat.format(dt)}';
  }

  String totime(int ms) {
    Duration dur = Duration(milliseconds: ms);
    String durString = dur.toString();
    List<String> splDur = durString.split('.');
    return 'Duration: ${splDur[0]}';
  }

  PositionService posService = PositionService();
  @override
  Widget build(BuildContext context) {
    var podsql = context.read<PodcastServices>();
    return WillPopScope(
      onWillPop: () {
        if (player.position > const Duration(minutes: 2)) {
          posService.savePosition(episodeName, player.position);
          return Future.value(true);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
          body: isLoaded
              ? SafeArea(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        backgroundColor: const Color(0x002e2e2e),
                        shadowColor: const Color(0x002e2e2e),
                        snap: true,
                        floating: true,
                        expandedHeight: 280,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            // add dummy image if error
                            child: Column(
                              children: [
                                const SizedBox(height: 40),
                                CachedNetworkImage(
                                  imageUrl: podcastImage,
                                  width: 200,
                                  errorWidget: (context, url, error) =>
                                      const Image(
                                          image: AssetImage(
                                              'assets/images/dd.png')),
                                  placeholder: (context, podcastImage) =>
                                      const Center(
                                          child: CircularProgressIndicator()),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Center(
                            child: PlayerButtons(player, isSelected, context)),
                      ),
                      SliverToBoxAdapter(
                        child: StreamBuilder<PositionData>(
                          stream: _positionDataStream,
                          builder: (context, snapshot) {
                            final positionData = snapshot.data;
                            return SliderBar(
                                audioPlayer: player,
                                duration:
                                    positionData?.duration ?? Duration.zero,
                                position:
                                    positionData?.position ?? Duration.zero,
                                bufferedPosition:
                                    positionData?.bufferedPosition ??
                                        Duration.zero);
                          },
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          int length = episodes.length;
                          final episode = episodes[length - index - 1];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 2, 20, 5),
                            child: Slidable(
                              actionPane: const SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxHeight: 175),
                                padding:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 4),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: tappedIndex == index
                                        ? Colors.white
                                        : Colors.grey,
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isSelected = true;
                                          tappedIndex = index;
                                          episodeName = episode.trackName!;
                                        });
                                        _scrollController.animateTo(0,
                                            duration:
                                                const Duration(seconds: 2),
                                            curve: Curves.easeInOutCirc);

                                        _init(episode);
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12),
                                            child:
                                                Text(episode.trackName ?? ''),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                dateToString(
                                                    episode.releaseDate ??
                                                        DateTime.now()),
                                                style: const TextStyle(
                                                    fontSize: 9),
                                              ),
                                              Text(
                                                totime(
                                                    episode.trackTimeMillis ??
                                                        0),
                                                style: const TextStyle(
                                                    fontSize: 9),
                                              )
                                            ],
                                          ),
                                          Text(
                                            episode.description ?? '',
                                            style:
                                                const TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                              actions: [
                                IconSlideAction(
                                  caption: 'Delete episode',
                                  iconWidget: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  color: Colors.grey[800],
                                  onTap: () async {
                                    File targetFile = File(episode.episodeUrl!);
                                    if (targetFile.existsSync()) {
                                      targetFile.deleteSync(recursive: true);
                                    }

                                    await podsql.deleteSavedEpisode(
                                        episode.episodeUrl!);
                                    if (savedEpisodes.length > 1) {
                                      await getSavedData();
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                )
                              ],
                            ),
                          );
                        }, childCount: episodes.length - 1),
                      )
                    ],
                  ),
                )
              : const Center(child: CircularProgressIndicator()),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndFloat,
          floatingActionButton: FloatingActionButton.small(
            onPressed: () {
              if (player.position > const Duration(minutes: 2)) {
                posService.savePosition(episodeName, player.position);
              }
              player.dispose();
              SystemChannels.platform.invokeMethod('SystemNavigator.pop');
            },
            child: const Icon(Icons.exit_to_app),
          )),
    );
  }
}
