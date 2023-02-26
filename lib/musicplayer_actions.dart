class MusicPlayerActions {
  static String _currentSong = "";
  static List<String> musicLibrary = [];
  static bool _isPlaying = false;

  Future<void> orderMusicLibrary() async {
    musicLibrary.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }

  Future<void> shuffleMusicLibrary() async {
    musicLibrary.shuffle();
  }

  Future<void> setMusicLibrary(List<String> list) async {
    musicLibrary = list;
  }

  List<String> getMusicLibrary() {
    return musicLibrary;
  }

  String getCurrentSong() {
    return _currentSong;
  }

  bool getIfSongPlaying() {
    return _isPlaying;
  }

  Future<void> playSong(cache) async {
    _isPlaying = true;
    await cache.loop(_currentSong);
  }

  Future<void> playNewSong(newSong, cache) async {
    _isPlaying = true;
    _currentSong = newSong;
    await cache.loop(_currentSong);
  }

  Future<void> pauseSong(cache) async {
    _isPlaying = false;
    var player = cache.fixedPlayer;
    await player?.pause();
  }

  Future<void> stopSong(cache) async {
    _isPlaying = false;
    var player = cache.fixedPlayer;
    await player?.stop();
  }

  Future<void> prevSong(cache) async {
    int index = musicLibrary.indexOf(_currentSong);
    index--;
    if (index < 0) {
      index = musicLibrary.length - 1;
    }
    _currentSong = musicLibrary[index];
    await cache.loop(_currentSong);
  }

  Future<void> nextSong(cache) async {
    int index = musicLibrary.indexOf(_currentSong);
    index++;
    if (index >= musicLibrary.length - 1) {
      index = 0;
    }

    if (index >= 0) {
      _currentSong = musicLibrary[index];
      await cache.loop(_currentSong);
    }
  }
}
