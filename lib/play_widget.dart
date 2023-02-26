import 'package:flutter/material.dart';

class PlayWidget extends StatelessWidget {
  final Function playHandler;

  final String songName;
  final int maxTextWidth;
  const PlayWidget(this.playHandler,
      {super.key, required this.songName, required this.maxTextWidth});

  @override
  Widget build(BuildContext context) {
    return songName.length < maxTextWidth
        ? SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => playHandler(songName),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 37, 25, 39),
              ),
              child: Text(
                songName,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 16, color: Colors.lightGreenAccent),
              ),
            ),
          )
        : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => playHandler(songName),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 37, 25, 39),
              ),
              child: Text(
                "${songName.substring(0, maxTextWidth - 4)} ...",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 16, color: Colors.lightGreenAccent),
              ),
            ),
          );
  }
}
