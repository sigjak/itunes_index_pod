import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'podcasts_favorite_model.dart';
import 'episode_favorite_model.dart';

class PodFavDatabase {
  static final PodFavDatabase instance = PodFavDatabase._initialize();
  static Database? _database;
  PodFavDatabase._initialize();

  Future _createDB(Database db, int version) async {
    const integer = 'INTEGER';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const intPrimary = 'INTEGER PRIMARY KEY';
    const textPrimary = "TEXT PRIMARY KEY";

    await db.execute('''CREATE TABLE $favoritePodcastsTable (
    ${PodcastFavFields.podcastName} $textPrimary,
    ${PodcastFavFields.podcastImage} $textType,
    ${PodcastFavFields.podcastFeed} $integer)
    ''');

    await db.execute('''CREATE TABLE $favoriteEpisodesTable
    (${EpisodeFavFields.id} $intPrimary,
    ${EpisodeFavFields.podcastName} $textType,
    ${EpisodeFavFields.podcastImage} $textType,
    ${EpisodeFavFields.episodeName} $textType,
    ${EpisodeFavFields.episodeUrl} $textType,
    ${EpisodeFavFields.episodeDate} $textType,
    ${EpisodeFavFields.episodeDuration} $integer,
    ${EpisodeFavFields.episodeDescription} $textType,
    ${EpisodeFavFields.timestamp} $integer,
    ${EpisodeFavFields.position} $integer,
    ${EpisodeFavFields.isDownloaded} $boolType,
    ${EpisodeFavFields.dloadLocation} $textType,
    UNIQUE(${EpisodeFavFields.episodeName}),
    FOREIGN KEY (${EpisodeFavFields.podcastName}) REFERENCES $favoritePodcastsTable (${PodcastFavFields.podcastName})
   ON DELETE CASCADE)''');
  }

  Future<Database> _initDB(String filename) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, filename);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future close() async {
    final db = await instance.database;
    db!.close();
  }

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _initDB('favorites.db');
      return _database;
    }
  }

  Future deleteDB() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'favorites.db');
    await deleteDatabase(path);
  }

  //////////////////// podcasts ////////////////////
  ///
  Future<PodFavorite> addFavoritePodcast(PodFavorite podFavorite) async {
    final db = await instance.database;
    await db!.insert(favoritePodcastsTable, podFavorite.toJson());
    return podFavorite;
  }

  //////////////////// Check if podcast in database ////////////////////
  ///         returning first found  as PodFavorite or throwing Exception

  Future<PodFavorite> getSingleFavoritePodcast(String podcastname) async {
    final db = await instance.database;
    final maps = await db!.query(favoritePodcastsTable,
        columns: PodcastFavFields.allFields,
        where: '${PodcastFavFields.podcastName} = ?',
        whereArgs: [podcastname]);
    if (maps.isNotEmpty) {
      // print('maps.length: ${maps.length}');
      return PodFavorite.fromJson(maps.first);
    } else {
      throw Exception('$podcastname not found');
    }
  }

  Future<List<PodFavorite>> getAllFavoritePodcasts() async {
    final db = await instance.database;
    final result = await db!.query(favoritePodcastsTable);
    // print(result.length);
    return result.map((e) => PodFavorite.fromJson(e)).toList();
  }

  Future<int> deleteSinglePodcast(String podcastname) async {
    final db = await instance.database;
    final result = db!.delete(favoritePodcastsTable,
        where: '${PodcastFavFields.podcastName} = ?', whereArgs: [podcastname]);
    return result;
  }

  /////////////////// episodes  ///////////////////////////////
  ////////////////   add favorite episode
  Future<EpisFavorite> addFavoriteEpisode(EpisFavorite episFavorite) async {
    final db = await instance.database;
    await db!.insert(favoriteEpisodesTable, episFavorite.toJson());
    return episFavorite;
  }

  //////////////  get all favorite episodes ////////////
  ///

  Future<List<EpisFavorite>> getAllFavoriteEpisodes() async {
    final db = await instance.database;
    final result = await db!.query(favoriteEpisodesTable);
    List<EpisFavorite> list =
        result.map((e) => EpisFavorite.fromJson(e)).toList();
    //print(list);
    return list;
  }

/////////////
///////////////////////get episodes from a single podcast /////////
  ///
  ///
  Future<List<EpisFavorite>> getAllPodEpisodesfromOnePodcast(
      String podcastname) async {
    final db = await instance.database;
    final result = await db!.query(
      favoriteEpisodesTable,
      where: '${EpisodeFavFields.podcastName} = ?',
      whereArgs: [podcastname],
    );
    List<EpisFavorite> list =
        result.map((e) => EpisFavorite.fromJson(e)).toList();
    return list;
  }

  /////////////////
  ///         Update  downloadLocation in episode
  ///
  Future<int> updateEpisode(String downloadLocation, String episodename) async {
    final db = await instance.database;
    final result = await db!.rawUpdate(
        'UPDATE favoriteEpisodesTable SET dloadLocation = ? WHERE episodeName = ?',
        [downloadLocation, episodename]);
    return result;
  }

  Future getSingleNamedEpisode(String episodename) async {
    final db = await instance.database;
    final result = await db!.query(favoriteEpisodesTable,
        where: '${EpisodeFavFields.episodeName} =?', whereArgs: [episodename]);
    List<EpisFavorite> epList =
        result.map((e) => EpisFavorite.fromJson(e)).toList();
    EpisFavorite one = epList[0];
    return one;
  }

//////////////////
  ///         Delete a single Saved episode
////
  Future<int> deleteSavedEpisode(String episodeLocation) async {
    final db = await instance.database;
    final result = await db!.rawDelete(
        'DELETE FROM favoriteEpisodesTable WHERE dloadLocation = ?',
        [episodeLocation]);
    return result;
  }
}
