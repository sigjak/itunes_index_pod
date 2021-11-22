import 'package:flutter/material.dart';
import './episode_favorite_model.dart';
import './podcasts_favorite_model.dart';
import './sql_db.dart';

class PodcastServices with ChangeNotifier {
  List<PodFavorite> favPodcasts = [];
  List<EpisFavorite> allFavoriteEpisodes = [];
  List<EpisFavorite> favSinglePodEpisodes = [];

////////////////////////       PODCASTS                ////////////////
  ///
  ///
  ///             Gettting all favorite podcasts and adding to List favPodcasts
  ///
  Future<String> getAllFavoritePodcasts() async {
    String result = 'OK';
    try {
      favPodcasts = await PodFavDatabase.instance.getAllFavoritePodcasts();
      notifyListeners();
      //print('in get: ${favPodcasts.length}');
    } catch (e) {
      result = readableError(e.toString());
    }
    return result;
  }

/////////////////////////
  ///
  ///               Adding a pocast to database and calling getAll FavPodcasts
  ///                     to add to List of favPodcasts
  ///

  Future<String> addPodcast(PodFavorite podFavorite) async {
    String result = 'OK';
    try {
      await PodFavDatabase.instance.addFavoritePodcast(podFavorite);
      getAllFavoritePodcasts();
    } catch (e) {
      result = readableError(e.toString());
    }
    return result;
  }

////////////////////////////////
  ///
  ///
  Future<bool> checkIfPodcastInDB(String podcastname) async {
    bool result = true;
    try {
      await PodFavDatabase.instance.getSingleFavoritePodcast(podcastname);
    } catch (e) {
      result = false;
    }
    return result;
  }

////////////////////////////
  Future<String> deleteSinglePodcast(podcastname) async {
    String result = 'OK';
    try {
      await PodFavDatabase.instance.deleteSinglePodcast(podcastname);
      getAllFavoritePodcasts();
    } catch (e) {
      result = e.toString();
    }
    return result;
  }

  /////////////////////////////////////////////////////
  Future<String> deleteDB() async {
    String result = 'DB deleted';
    try {
      await PodFavDatabase.instance.deleteDB();
    } catch (e) {
      result = 'failed';
    }
    return result;
  }

  ///////////////  EPISODES  ////////////////////////
  ///
  //////////////  Add favorite Episode /////////////
  Future<String> addFavoriteEpisode(EpisFavorite episFavorite) async {
    String result = 'Episode added';
    try {
      await PodFavDatabase.instance.addFavoriteEpisode(episFavorite);
      notifyListeners();
    } catch (e) {
      result = readableError(e.toString());
    }
    return result;
  }

  //////////////////////////////////////////////
  ///////////////////// Get all favorite Episodes ///////////////////
  ///

  Future<String> getAllFavoriteEpisodes() async {
    String result = 'OK';
    try {
      allFavoriteEpisodes =
          await PodFavDatabase.instance.getAllFavoriteEpisodes();
      notifyListeners();
    } catch (e) {
      result = 'Error';
    }
    return result;
  }

  Future<EpisFavorite> getSingleEpisode(String episodename) async {
    EpisFavorite? singleEpisode;
    try {
      singleEpisode =
          await PodFavDatabase.instance.getSingleNamedEpisode(episodename);
      //return singleEpisode!;
    } catch (e) {
      print('ERROR No such episode in favorites');
    }
    return singleEpisode!;
  }

////////////////////////////////////////////
  // get all episoded from a single podcast
  ///////
  Future<String> getEpisodesFromSinglePodcast(String podcastname) async {
    String result = 'OK';
    try {
      favSinglePodEpisodes = [];

      favSinglePodEpisodes = await PodFavDatabase.instance
          .getAllPodEpisodesfromOnePodcast(podcastname);
      notifyListeners();
    } catch (e) {
      result = readableError(e.toString());
    }
    return result;
  }

////////////////////
  ///
////////  Update save location in episode table
  Future<String> updateSaveLocation(String location, String name) async {
    String result = 'OK';

    try {
      await PodFavDatabase.instance.updateEpisode(location, name);
    } catch (e) {
      result = e.toString();
      print(e.toString());
    }
    return result;
  }

  ///////////
  ///            Delete single saved episode
  /// //
  Future<String> deleteSavedEpisode(String episodeLocation) async {
    String result = 'OK';

    try {
      await PodFavDatabase.instance.deleteSavedEpisode(episodeLocation);
      notifyListeners();
    } catch (e) {
      result = e.toString();
    }
    return result;
  }
}

String readableError(String message) {
  if (message.contains('UNIQUE constraint failed')) {
    return 'This podcast already exists in the database!';
  }
  if (message.contains('no such column: episodeUrl')) {
    return 'No favorite episode for this podcast!';
  }
  if (message.contains('(code 787 SQLITE_CONSTRAINT_FOREIGNKEY)')) {
    return 'Add this Podcast to favorites before saving.';
  }
  if (message.contains('not found in the database')) {
    return 'The podcast does not exist in the database. Please add to database';
  }

  return message;
}
