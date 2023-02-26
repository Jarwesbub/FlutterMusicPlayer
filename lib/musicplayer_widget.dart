import 'package:flutter/material.dart';

class MusicPlayerWidget extends StatelessWidget {
  final Function buttonPress;
  final double iconSize;
  final String currentSong;
  final bool isPlaying;
  const MusicPlayerWidget(
    this.buttonPress, {
    super.key,
    required this.currentSong,
    required this.isPlaying,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 10, 9, 12),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        iconSize: iconSize,
        onTap: (value) => buttonPress(value),
        elevation: 0,
        items: !isPlaying
            ? const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.skip_previous), label: ""),
                BottomNavigationBarItem(
                    icon: Icon(Icons.play_arrow), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.stop), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.skip_next), label: ""),
              ]
            : const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.skip_previous), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.pause), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.stop), label: ""),
                BottomNavigationBarItem(icon: Icon(Icons.skip_next), label: ""),
              ],
      ),
    );
  }
}
