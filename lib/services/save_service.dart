import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'dart:io';

class SaveService with ChangeNotifier {
  String? podcastName;
  String? episodeName;
  double? progress = 0.0;
  CancelToken token = CancelToken();

  void refreshToken() {
    if (token.isCancelled) {
      token = CancelToken();
    }
  }

  ////      get sd card
  //
  Future<String> getSdPath() async {
    final status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      List<Directory>? extList = await getExternalStorageDirectories();
      //  List<String> splitList = extList![1].path.split('/');
      List<String> splitList = [];
      if (extList!.length == 2) {
        splitList = extList[1].path.split('/');
      } else {
        splitList = extList[0].path.split('/');
      }

      String sdPath = '';
      for (int i = 1; i < splitList.length; i++) {
        if (splitList[i] == 'Android') break;
        sdPath += '/${splitList[i]}';
      }
      return sdPath;
    } else {
      return 'denied';
    }
  }

  //
  //           Get directory and path
  //

  Future<String> getDirPath(String podcastName) async {
    String baseDirPath = await getSdPath();
    // print(baseDirPath);
    // print(baseDirPath + '/Podcasts/$podcastName');
    podcastName = podcastName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ' ').trim();
    final Directory dir = Directory('$baseDirPath/Podcasts/$podcastName');
    if (await dir.exists()) {
      return dir.path;
    } else {
      await dir.create(recursive: true);
      return dir.path;
    }
  }

  Future<String> downloadLocation(String podcastName, episodeTitle) async {
    //clean podcastName
    podcastName = podcastName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ' ').trim();
    String cleanTitle =
        episodeTitle.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ' ').trim();
    String cleanerTitle = cleanTitle.replaceAll(RegExp('\\s+'), '');
    String fileName = cleanerTitle.substring(0, min(cleanerTitle.length, 20));
    String dirPath = await getDirPath(podcastName);
    final savePath = dirPath + '/$fileName.mp3';
    return savePath;
  }

  Future<String> saveEpisode(
      String urlPath, String podcastName, String episodeTitle) async {
    Dio dio = Dio();
    final savePath = await downloadLocation(podcastName, episodeTitle);

    try {
      await dio.download(urlPath, savePath, cancelToken: token,
          onReceiveProgress: (downloaded, totalsize) {
        progress = downloaded / totalsize;
        notifyListeners();
        //print(progress);
      });
      progress = 0.0;
      notifyListeners();
      // print('downloaded');
      return savePath;
    } catch (e) {
      //print(e.toString());
      throw Exception('problems');
    }
  }

  Future getEpisodesInDirectory(String podcastName) async {
    String path = await getDirPath(podcastName);
    //print(path);

    Directory dir = Directory(path);
    dir.list(recursive: false).forEach((element) {
      //print(element);
    });
  }
}
