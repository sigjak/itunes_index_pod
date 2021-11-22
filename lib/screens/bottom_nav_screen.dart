import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'favorite_screen.dart';
import 'search_screen.dart';
import 'trend_screen.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;
  List screens = [
    const FavoriteScreen(),
    const SearchScreen(),
    const TrendScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(
              label: 'Favorites', icon: Icon(Icons.favorite)),
          BottomNavigationBarItem(label: 'Search', icon: Icon(Icons.search)),
          BottomNavigationBarItem(
              label: 'Trends', icon: Icon(Icons.trending_up)),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          showExitAlert(context);
          // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
        child: const Icon(Icons.exit_to_app),
      ),
    );
  }
}

showExitAlert(BuildContext context) {
  // Widget okButton = TextButton(
  //   onPressed: () {
  //     Navigator.of(context).pop();
  //   },
  //   child: Text('OK'),
  // );
  // AlertDialog exitAlert = AlertDialog(
  //   title: Text('Exit app?'),

  //   actions: [okButton],
  // );
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit app?'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No')),
            TextButton(
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ))
          ],
        );
      });
}
