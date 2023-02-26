import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'music_player.dart';
import './musicplayer_actions.dart';
import 'musicplayer_widget.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreen();
}

class _PlayScreen extends State<PlayScreen> {
  final cache = MusicPlayer().getCache();

  Future<void> buttonCheck(int buttonIndex) async {
    setState(() {
      bool isPlaying = MusicPlayerActions().getIfSongPlaying();

      if (buttonIndex == 0) {
        MusicPlayerActions().prevSong(cache);
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
      }
    });
  }

  String getCurrentSongText() {
    String txt = MusicPlayerActions().getCurrentSong();
    return "$txt                  ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 29, 27, 32),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 56, 52, 63),
          title: const Text('Music Player Screen'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/background.png',
            color: const Color.fromARGB(228, 134, 196, 63),
          ),
        ),
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            alignment: Alignment.topCenter,
            width: double.infinity,
            height: 50,
            color: const Color.fromARGB(255, 10, 9, 12),
            child: Marquee(
              text: getCurrentSongText(),
              style:
                  const TextStyle(fontSize: 20, color: Colors.lightGreenAccent),
            ),
          ),
          MusicPlayerWidget(
            buttonCheck,
            iconSize: 42,
            currentSong: MusicPlayerActions().getCurrentSong(),
            isPlaying: MusicPlayerActions().getIfSongPlaying(),
          ),
        ]));
  }
}
