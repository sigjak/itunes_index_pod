import 'package:shared_preferences/shared_preferences.dart';

class PositionService {
  savePosition(String episodeName, Duration pos) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String durString = pos.inMilliseconds.toString();
    String dateString = DateTime.now().millisecondsSinceEpoch.toString();
    List<String> stringList = [durString, dateString];
    prefs.setStringList(episodeName, stringList);
  }

  Future<Duration> getSavedPosition(String episodeName) async {
    Duration savedPosition = Duration.zero;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(episodeName)) {
      List<String> myPosList = prefs.getStringList(episodeName)!;
      int pos = int.parse(myPosList[0]);
      savedPosition = Duration(milliseconds: pos);
    }
    return savedPosition;
  }

  removeOldKeys() async {
    int limit =
        DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getKeys();
    for (String key in prefs.getKeys()) {
      List ll = prefs.getStringList(key)!;
      int value = int.parse(ll[1]);
      if (value < limit) {
        prefs.remove(key);
      }
    }
  }
}
