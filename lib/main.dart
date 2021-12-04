import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//import './providers/podind_epis_provider.dart';
import './providers/search_provider.dart';
//import 'package:itunes_pod/screens/bottom_nav_screen.dart';
import './screens/init_page.dart';
import './services/save_service.dart';
import './sql/podcast_sql_services.dart';
import './providers/episode_provider.dart';
import 'providers/trend_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Trends()),
    ChangeNotifierProvider(create: (_) => ItunesEpisodes()),
    ChangeNotifierProvider(create: (_) => PodcastServices()),
    ChangeNotifierProvider(create: (_) => SaveService()),
    ChangeNotifierProvider(create: (_) => SearchByName()),
    //   ChangeNotifierProvider(create: (_) => PodIndexEpisodeProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
      ),
      //  home: const BottomNav(),
      home: const InitScreen(),
    );
  }
}
