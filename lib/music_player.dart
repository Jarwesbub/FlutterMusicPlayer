import 'package:audioplayers/audioplayers.dart';

class MusicPlayer {
  final _cache = AudioCache(
      prefix: "assets/music/", fixedPlayer: AudioPlayer(playerId: "player0"));

  AudioCache getCache() {
    return _cache;
  }
}
