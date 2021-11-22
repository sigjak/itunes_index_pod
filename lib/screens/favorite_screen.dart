import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:itunes_pod/screens/play_saved.dart';

import 'package:provider/provider.dart';
import './audio_screen.dart';
import '/sql/episode_favorite_model.dart';
import '../services/save_service.dart';
//import '../sql/podcasts_favorite_model.dart';
import '../sql/podcast_sql_services.dart';
//import '../screens/search_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<EpisFavorite> allFavoriteEpisodes = [];
  bool isLoaded = false;
  // bool isEpisodes = false;
  // AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    var podService = context.read<PodcastServices>();
    podService.getAllFavoritePodcasts();
    podService.getAllFavoriteEpisodes().then((_) {
      allFavoriteEpisodes = podService.allFavoriteEpisodes;
      // print(' Number of favorite episodes: ${allFavoriteEpisodes.length}');
      setState(() {
        isLoaded = true;
      });
    });
  }

  Future<bool> checkIfSomethingSaved(podcastname) async {
    bool result = true;
    var path = (await context.read<SaveService>().getDirPath(podcastname));
    var dir = Directory(path);

    if (await dir.list().isEmpty) {
      result = false;
    }
    return result;
    // check also if in sql database
  }

  clearCache() {
    DefaultCacheManager().emptyCache();
    imageCache!.clear();
    imageCache!.clearLiveImages();
    setState(() {});
  }

  Future<void> _showDeleteAlert(podcast) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning !'),
          content: const Text(
              'This will delete everything related to this podcast and can NOT be undone!'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                String path = await context
                    .read<SaveService>()
                    .getDirPath(podcast.podcastName);

                final dir = Directory(path);
                dir.deleteSync(recursive: true);

                await context
                    .read<PodcastServices>()
                    .deleteSinglePodcast(podcast.podcastName);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var pod = context.watch<PodcastServices>();

    return Scaffold(
      drawer: const Drawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              // TextButton(
              //     onPressed: () async {
              //       String baseDir =
              //           await context.read<SaveService>().getSdPath();
              //       String path = '$baseDir/Podcasts';
              //       Directory dir = Directory(path);
              //       dir.list(recursive: false).forEach((element) {
              //         element.deleteSync(recursive: true);
              //       });
              //       await context.read<PodcastServices>().deleteDB();
              //       SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              //     },
              //     child: const Text('DeleteEverything')),
              TextButton(
                  onPressed: clearCache,
                  child: const Text(
                    'Clear cache',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ],
            snap: true,
            floating: true,
            expandedHeight: 200,
            flexibleSpace: const FlexibleSpaceBar(
              centerTitle: true,
              background: Image(
                image: AssetImage(
                  'assets/images/radioAntenna.jpg',
                ),
                fit: BoxFit.cover,
              ),
              title: Text('Favorite Podcasts'),
            ),
          ),
          isLoaded
              ? pod.favPodcasts.isNotEmpty
                  ? SliverPadding(
                      padding: const EdgeInsets.all(16.0),
                      sliver: SliverFixedExtentList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final podcast = pod.favPodcasts[index];

                              return Slidable(
                                actionPane: const SlidableDrawerActionPane(),
                                actionExtentRatio: 0.20,
                                actions: [
                                  SlideAction(
                                      onTap: () async {
                                        bool check =
                                            await checkIfSomethingSaved(
                                                podcast.podcastName);
                                        if (check) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PlaySaved(
                                                podcastName:
                                                    podcast.podcastName,
                                                itunesId: podcast.podcastFeed
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                    'Nothing saved!',
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  ),
                                                  behavior: SnackBarBehavior
                                                      .floating));
                                        }
                                      },
                                      decoration: BoxDecoration(
                                          color: Colors.teal[900],
                                          border: Border.all(
                                              width: 2, color: Colors.white)),
                                      child: const Text(
                                        'Saved Episodes',
                                        textAlign: TextAlign.center,
                                      ))
                                ],
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AudioScreen(
                                                itunesId: podcast.podcastFeed
                                                    .toString(),
                                              )),
                                    );
                                  },
                                  child: Card(
                                    elevation: 5,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        foregroundImage:
                                            CachedNetworkImageProvider(
                                                podcast.podcastImage),
                                      ),
                                      title: Text(podcast.podcastName),
                                      trailing: IconButton(
                                        onPressed: () {
                                          _showDeleteAlert(podcast);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: pod.favPodcasts.length,
                          ),
                          itemExtent: 60),
                    )
                  : const SliverToBoxAdapter(
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text(
                          'No favorites',
                          style: TextStyle(fontSize: 40),
                        ),
                      )),
                    )
              : const SliverToBoxAdapter(
                  child: Center(
                  child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator()),
                )),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      // floatingActionButton: FloatingActionButton.small(
      //   onPressed: () {
      //     SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      //   },
      //   child: const Icon(Icons.exit_to_app),
      //),
    );
  }
}

class Drawer extends StatelessWidget {
  const Drawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 400,
              width: 200,
              color: Colors.black54,
              child: const Image(
                image: AssetImage('assets/images/gos2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 50,
              top: 300,
              child: ElevatedButton(
                onPressed: () async {
                  await deleteAll(context);
                  Navigator.of(context).pop();
                },
                child: const Text('DeleteEverything'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Future<void> deleteAll(context) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure ?'),
          content: SingleChildScrollView(
            child: ListBody(children: const [
              Text('This can\'t be undone !!'),
              Text(
                'Database and saved episodes will be deleted.',
                style: TextStyle(fontSize: 12),
              )
            ]),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel')),
            TextButton(
                onPressed: () async {
                  String baseDir =
                      await context.read<SaveService>().getSdPath();
                  String path = '$baseDir/Podcasts';
                  Directory dir = Directory(path);
                  dir.list(recursive: false).forEach((element) {
                    element.deleteSync(recursive: true);
                  });
                  await context.read<PodcastServices>().deleteDB();
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ))
          ],
        );
      });
}
