import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/models/models.dart';
import 'package:music_player/provider/mini_player_controller.dart';
import 'package:music_player/resources/firestore_methods.dart';
import 'package:music_player/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';

class SongPage extends StatefulWidget {
  const SongPage({Key? key}) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  final FirebaseFavoriteMethods _firebaseMethods = FirebaseFavoriteMethods();

  bool isLiked = false;
  final AudioPlayer _player = GetIt.I<AudioPlayer>();
  double _sliderValue = 0.0;
  StreamSubscription<Duration>? _positionSubscription;
  bool _isPlayingg = false;
  bool replay = false;
  bool _isLoop = false;
  var userData = {};

  @override
  void initState() {
    super.initState();

    _positionSubscription = _player.positionStream.listen((Duration position) {
      if (mounted) {
        setState(() {
          _sliderValue = position.inMilliseconds.toDouble();
        });
      }
    });
    _isPlayingg =
        Provider.of<MiniPlayerProvider>(context, listen: false).isPlaying;

    _player.playerStateStream.listen((PlayerState state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          replay = true;
        });
        if (_player.loopMode == LoopMode.one) {
          _player.seek(Duration.zero);
        }
      }
    });
  }

  void toggleLoopMode() {
    final currentLoopMode = _player.loopMode;

    if (currentLoopMode == LoopMode.off) {
      _player.setLoopMode(LoopMode.one);
      setState(() {
        _isLoop = true;
      });
    } else {
      _player.setLoopMode(LoopMode.off);
      setState(() {
        _isLoop = false;
      });
    }
  }

  void skip(bool isBackward, bool isForward) {
    final miniPlayerProvider =
        Provider.of<MiniPlayerProvider>(context, listen: false);
    final currentIndex = miniPlayerProvider.index;
    final playlistLength = miniPlayerProvider.playlistLength;

    if (playlistLength > 1) {
      int nextIndex;

      if (miniPlayerProvider.isShuffleMode) {
        final playlist = miniPlayerProvider.currentPlaylist;
        if (playlist != null) {
          final random = Random();
          nextIndex = random.nextInt(playlist.songs.length);
        } else {
          if (isForward) {
            nextIndex = (currentIndex + 1) % playlistLength;
          } else {
            nextIndex = (currentIndex - 1 + playlistLength) % playlistLength;
          }
        }
      } else {
        if (isForward) {
          nextIndex = (currentIndex + 1) % playlistLength;
        } else {
          nextIndex = (currentIndex - 1 + playlistLength) % playlistLength;
        }
      }

      final nextSong = miniPlayerProvider.currentPlaylist?.songs[nextIndex];

      if (nextSong != null) {
        miniPlayerProvider.play(nextSong);
        miniPlayerProvider.setInfo(
            nextIndex, playlistLength, miniPlayerProvider.currentPlaylist!);
      }
    } else {
      _player.seek(Duration.zero);
    }
  }
//   void toggleFavoriteStatus() async {
//   final miniPlayerProvider =
//       Provider.of<MiniPlayerProvider>(context, listen: false);
//   final Song? currentSong = miniPlayerProvider.currentSong;

//   if (currentSong == null) {
//     return;
//   }
//   final String uid = FirebaseAuth.instance.currentUser!.uid;
//     await _firebaseMethods.addSongToFavorites(uid, currentSong);
//   setState(() {
//     isLiked = !isLiked;
//   });
// }


  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Song? song =
        Provider.of<MiniPlayerProvider>(context, listen: false).currentSong;
    double maxSliderValue = _player.duration?.inMilliseconds.toDouble() ?? 0.0;
    _isPlayingg =
        Provider.of<MiniPlayerProvider>(context, listen: false).isPlaying;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Now Playing',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
            // toggleFavoriteStatus();
            },
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              size: 28,
              color: isLiked ? Colors.red : Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              // Add logic for more options
            },
            icon: const Icon(
              Icons.more_vert,
              size: 28,
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(song!.image[2].link),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 260),

                Text(
                  song.name.unescapeHtml(),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Album: ${song.album.name.unescapeHtml()}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Artist: ${song.primaryArtists.unescapeHtml()}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Year: ${song.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Language: ${song.language}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          skip(true, false);
                        },
                        iconSize: 36,
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 32),
                      FloatingActionButton(
                        onPressed: () async {
                          if (replay) {
                            _player.seek(Duration.zero);
                          } else if (_isPlayingg) {
                            _player.pause();
                          } else {
                            _player.play();
                          }
                          setState(() {
                            _isPlayingg = !_isPlayingg;
                            replay = false;
                          });
                        },
                        backgroundColor: Colors.white,
                        child: Icon(
                          _isPlayingg ? Icons.pause : Icons.play_arrow,
                          color: Colors.black,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 32),
                      IconButton(
                        onPressed: () {
                          skip(false, true);
                        },
                        iconSize: 36,
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Slider
                Slider(
                  value: _sliderValue.clamp(0.0, maxSliderValue),
                  onChanged: (value) {
                    _player.seek(Duration(milliseconds: value.toInt()));
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                  min: 0.0,
                  max: maxSliderValue,
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey[600],
                ),
                const SizedBox(height: 26),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        toggleLoopMode();
                      },
                      icon: Icon(
                        Icons.repeat,
                        size: 28,
                        color: _isLoop ? Colors.green : Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Provider.of<MiniPlayerProvider>(context, listen: false)
                            .toggleShuffleMode();
                      },
                      icon: Icon(
                        Icons.shuffle,
                        color: Provider.of<MiniPlayerProvider>(context,
                                    listen: false)
                                .isShuffleMode
                            ? Colors.green
                            : Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
