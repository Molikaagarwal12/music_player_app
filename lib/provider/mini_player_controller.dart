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
  double _savedSliderValue = 0.0;

  MiniPlayerProvider() {
    _player.playerStateStream.listen(_playerStateChanged);
  }
  bool get isPlaying => _isPlaying;
  bool get isMiniPlayerVisible => _isMiniPlayerVisible;
  Song? get currentSong => _currentSong;
  bool get isLoading => _isLoading;
  double get savedSliderValue => _savedSliderValue;
  void setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void saveSliderValue(double value) {
    _savedSliderValue = value;
    notifyListeners();
  }

  void _playerStateChanged(PlayerState state) {
    if (state.processingState == ProcessingState.completed ||
        state.processingState == ProcessingState.idle) {
      _isPlaying = false;
      saveSliderValue(
          0.0); // Reset slider value when playback completes or stops
      notifyListeners();
    } else if (state.playing) {
      _isPlaying = true;
      notifyListeners();
    } else if (!state.playing) {
      _isPlaying = false;
      notifyListeners();
    }
  }

  void toggleMiniPlayerVisibility() {
    _isMiniPlayerVisible = !_isMiniPlayerVisible;
    if (!_isMiniPlayerVisible) {
      _player.stop();
      saveSliderValue(0.0);
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

  void play(Song song, {Duration? initialPosition}) async {
    if (_currentSong != song) {
      _currentSong = song;

      await _player.setUrl(song.downloadUrl[2].link);
      if (initialPosition != null) {
        await _player.seek(initialPosition); // Seek to initial position
      }
      _player.play();
      _isPlaying = true;
    } else {
      if (!_isPlaying) {
        _player.play();
        _isPlaying = true;
      } else {
        _player.pause();
        _isPlaying = false;
      }
    }
    saveSliderValue(_player.position.inSeconds.toDouble()); // Save slider value
    notifyListeners();
  }

void signOut() {
    if (_isPlaying) {
      _player.stop();
      _isPlaying = false;
      _isMiniPlayerVisible = false;
      notifyListeners();
    }
  }
  void skipForward() {
    // Implement skip forward logic
  }

  void skipBack() {
    // Implement skip back logic
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
