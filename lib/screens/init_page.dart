import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itunes_pod/screens/bottom_nav_screen.dart';
import 'dart:io';

import 'package:itunes_pod/screens/favorite_screen.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({Key? key}) : super(key: key);

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  bool isConnected = true;
  late bool itunesValue;

  @override
  void initState() {
    connCheck();
    itunesPodindex(true);
    super.initState();
  }

  Future<void> itunesPodindex(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('itunesValue', value);
    setState(() {
      itunesValue = value;
    });
  }

  Future<void> checkNet() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNav()),
        );
      }
    } on SocketException catch (_) {
      setState(() {
        isConnected = false;
      });
    }
  }

  Future<void> connCheck() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.mobile) {
      checkNet();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      checkNet();
    } else if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isConnected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isConnected
            ? const CircularProgressIndicator()
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No Internet!',
                      style: TextStyle(fontSize: 45, color: Colors.red),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavoriteScreen(
                                        isConnected: isConnected,
                                      )));
                        },
                        child: const Text('Play saved episodes'))
                  ],
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        },
        child: const Icon(Icons.exit_to_app),
      ),
    );
  }
}
