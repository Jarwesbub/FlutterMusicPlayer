import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player/play_screen.dart';
import 'package:music_player/music_player.dart';
import './play_widget.dart';
import './musicplayer_widget.dart';
import './musicplayer_actions.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() {
    return _MainScreen();
  }
}

class _MainScreen extends State<MainScreen> {
  final cache = MusicPlayer().getCache();
  final int _maxWidgetTextWidth = 45;
  String _currentSong = '';
  int currentTabIndex = 0;
  //bool isPlaying = false;
  bool isShuffleOn = false;

  List<PlayWidget> playWidgetList = [];

  @override
  void initState() {
    super.initState();
    loadMusicFiles();
    //createPlayWidgets();
  }

  Future<void> loadMusicFiles() async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    List<String> musicList = [];

    for (var key in manifestMap.keys) {
      if (key.contains('music/') && key.contains('.mp3')) {
        String track = key.substring(13, key.length);
        musicList.add(track);
      }
    }
    musicList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    setState(() {
      MusicPlayerActions()
          .setMusicLibrary(musicList)
          .then((value) => MusicPlayerActions().orderMusicLibrary())
          .then((value) => createPlayWidgets());
    });
  }

  Future<void> createPlayWidgets() async {
    List<String> musicList = MusicPlayerActions().getMusicLibrary();
    playWidgetList.clear();
    for (var song in musicList) {
      playWidgetList.add(PlayWidget(
        musicPlayWidget,
        songName: song,
        maxTextWidth: _maxWidgetTextWidth,
      ));
    }
  }

  Future<void> musicPlayWidget(String songName) async {
    bool isPlaying = MusicPlayerActions().getIfSongPlaying();
    if (!isPlaying || _currentSong != songName) {
      MusicPlayerActions().playNewSong(songName, cache);
    } else {
      MusicPlayerActions().pauseSong(cache);
    }
    setState(() {
      _currentSong = songName;
      isPlaying;
    });
  }

  Future<void> orderList() async {
    setState(() {
      isShuffleOn = false;
      MusicPlayerActions().orderMusicLibrary();
    });
  }

  Future<void> shuffleList() async {
    setState(() {
      isShuffleOn = true;
      MusicPlayerActions().shuffleMusicLibrary();
    });
  }

  Future<void> buttonCheck(int buttonIndex) async {
    setState(() {
      bool isPlaying = MusicPlayerActions().getIfSongPlaying();
      if (buttonIndex == 0) {
        MusicPlayerActions().prevSong(cache);
        _currentSong = MusicPlayerActions().getCurrentSong();
      } else if (buttonIndex == 1) {
        if (!isPlaying) {
          MusicPlayerActions().playSong(cache);
        } else {
          MusicPlayerActions().pauseSong(cache);
        }
        isPlaying = !isPlaying;
      } else if (buttonIndex == 2) {
        isPlaying = false;
        MusicPlayerActions().stopSong(cache);
      } else if (buttonIndex == 3) {
        MusicPlayerActions().nextSong(cache);
        _currentSong = MusicPlayerActions().getCurrentSong();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: const Color.fromARGB(255, 10, 9, 12),
          appBar: AppBar(
            title: const Text("Music Player"),
            backgroundColor: const Color.fromARGB(255, 56, 52, 63),
            foregroundColor: Colors.white,
            actions: [
              !isShuffleOn
                  ? IconButton(
                      onPressed: shuffleList,
                      icon: const Icon(Icons.format_list_bulleted))
                  : IconButton(
                      onPressed: orderList, icon: const Icon(Icons.shuffle)),
              PopupMenuButton(
                  color: const Color.fromARGB(255, 70, 65, 80),
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          padding: const EdgeInsets.all(2),
                          onTap: loadMusicFiles,
                          child: const Text(
                            "Update List",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ]),
            ],
          ),
          body: ListView.builder(
              padding: const EdgeInsets.all(2),
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return (Column(
                  children: playWidgetList,
                ));
              }),
          bottomNavigationBar: SizedBox(
              height: 120,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Expanded(
                  flex: 2,
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PlayScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 56, 52, 63)),
                        child: const Icon(Icons.navigate_next))
                  ]),
                ),
                Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.topCenter,
                            color: const Color.fromARGB(255, 10, 9, 12),
                            child: Marquee(
                              text: "$_currentSong                   ",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.lightGreenAccent),
                            ),
                          ),
                        ),
                        Expanded(
                          child: MusicPlayerWidget(
                            buttonCheck,
                            iconSize: 32,
                            currentSong: _currentSong,
                            isPlaying: MusicPlayerActions().getIfSongPlaying(),
                          ),
                        ),
                      ],
                    ))
              ]))),
    );
  }
}
