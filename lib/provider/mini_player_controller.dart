import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

import '../models/song.dart';

class MiniPlayerProvider extends ChangeNotifier {
  final AudioPlayer _player = GetIt.I<AudioPlayer>();

  Song? _currentSong;
  bool _isPlaying = false;
  bool _isMiniPlayerVisible = false;
  bool _isLoading = false;

  MiniPlayerProvider() {
    _player.playerStateStream.listen(_playerStateChanged);
  }

  bool get isPlaying => _isPlaying;
  bool get isMiniPlayerVisible => _isMiniPlayerVisible;
  Song? get currentSong => _currentSong;
  bool get isLoading => _isLoading;

  void setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void _playerStateChanged(PlayerState state) {
    if (state.processingState == ProcessingState.completed) {
      _isPlaying = false;
      notifyListeners();
    }
  }

  void toggleMiniPlayerVisibility() {
    _isMiniPlayerVisible = !_isMiniPlayerVisible;
    if (!_isMiniPlayerVisible) {
      _player.stop();
    }
    notifyListeners();
  }

  void showMiniPlayer() {
    _isMiniPlayerVisible = true;
    notifyListeners();
  }

  void hideMiniPlayer() {
    _isMiniPlayerVisible = false;
    notifyListeners();
  }

   void play(Song song) async {
  if (_currentSong != song) {
    _currentSong = song;
    await _player.setUrl(song.downloadUrl[2].link);
    _player.play(); // Start playback immediately
  } else {
    if (!_isPlaying) {
      await _player.play(); // Start playback if not playing
    } else {
      await _player.pause();
    }
  }

  _isPlaying = _player.playing; // Update _isPlaying based on player state
  notifyListeners();
}

  void skipForward() {
    // Implement skip forward logic
  }

  void skipBack() {
    // Implement skip back logic
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
