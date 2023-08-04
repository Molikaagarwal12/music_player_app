import 'package:flutter/cupertino.dart';
import 'package:music_player/widgets/playlist_song_details.dart';

import 'notifier/play_button_notifier.dart';
import 'notifier/progress_notifier.dart';
import 'notifier/repeat_notifier.dart';
import 'package:audio_service/audio_service.dart';
import 'services/service_locator.dart';

class PageManager {
  final _audioHandler = getIt<AudioHandler>();
  // Listeners: Updates going to the UI
  final currentSongTitleNotifier = ValueNotifier<String>('');
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final playButtonNotifier = PlayButtonNotifier();
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  // Events: Calls coming from the UI
  void init() async {
  // await _loadPlaylist();
}

// Future<void> _loadPlaylist() async {
//   final songRepository = getIt<PlaylistDetailPage>();
//   final playlist = await songRepository.
//   final mediaItems = playlist
//       .map((song) => MediaItem(
//             id: song['id'] ?? '',
//             album: song['album'] ?? '',
//             title: song['title'] ?? '',
//             extras: {'url': song['url']},
//           ))
//       .toList();
//   _audioHandler.addQueueItems(mediaItems);
// }
  void play() {}
  void pause() {}
  void seek(Duration position) {}
  void previous() {}
  void next() {}
  void repeat() {}
  void shuffle() {}
  void add() {}
  void remove() {}
  void dispose() {}
}