import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import '../models/playlist.dart';
import '../models/song.dart';

class MiniPlayerProvider<T> extends ChangeNotifier {
  final AudioPlayer _player = GetIt.I<AudioPlayer>();
  Song? _currentSong;
  bool _isPlaying = false;
  bool _isMiniPlayerVisible = false;
  bool _isLoading = false;
  
  int _index = 0;
  int _playlistLength = 0;
  T? currentplaylist;
  bool _isShuffleMode = false;

  MiniPlayerProvider() {
    _player.playerStateStream.listen(_playerStateChanged);
  }
  bool get isPlaying => _isPlaying;
  bool get isMiniPlayerVisible => _isMiniPlayerVisible;
  Song? get currentSong => _currentSong;
  bool get isLoading => _isLoading;
  
  void setInfo(int index, int playlistLength, T playlist) {
    _index = index;
    _playlistLength = playlistLength;
    currentplaylist = playlist;
    notifyListeners();
  }

  int get index => _index;
  int get playlistLength => _playlistLength;
  T? get currentPlaylist => currentplaylist;
  bool get isShuffleMode => _isShuffleMode;

  void setLoadingState(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  

  void _playerStateChanged(PlayerState state) {
    if (state.processingState == ProcessingState.completed) {
      _isPlaying = false;
      notifyListeners();
    } else if (state.playing) {
      _isPlaying = true;
      notifyListeners();
    } else if (!state.playing) {
      _isPlaying = false;
      notifyListeners();
    }
  }
void toggleShuffleMode() {
    _isShuffleMode = !_isShuffleMode;
    notifyListeners();
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

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
