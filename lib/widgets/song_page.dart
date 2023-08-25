import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:json_annotation/json_annotation.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/provider/mini_player_controller.dart';
import 'package:music_player/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../models/song.dart';

class SongPage extends StatefulWidget {
  final Song song;

  const SongPage({
    Key? key,
    required this.song,
  }) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

@JsonSerializable()
class _SongPageState extends State<SongPage> {
  bool isLiked = false;
  final AudioPlayer _player = GetIt.I<AudioPlayer>();
  double _sliderValue = 0.0;
  StreamSubscription<Duration>? _positionSubscription;
  bool _isPlayingg = false;

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
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxSliderValue = _player.duration?.inMilliseconds.toDouble() ?? 0.0;

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
              setState(() {
                isLiked = !isLiked;
              });
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.song.image[2].link),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
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
          child: Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 260),
                Text(
                  widget.song.name.unescapeHtml(),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Album: ${widget.song.album.name.unescapeHtml()}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Artist: ${widget.song.primaryArtists.unescapeHtml()}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Year: ${widget.song.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Language: ${widget.song.language}',
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
                        onPressed: () {},
                        iconSize: 36,
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 32),
                      FloatingActionButton(
                        onPressed: () async {
                          if (_isPlayingg) {
                            _player.pause();
                          } else {
                            _player.play();
                          }
                          setState(() {
                            _isPlayingg =
                                !_isPlayingg; // Toggle the playing state
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
                          // Implement the logic for next song
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
                        // Add logic for repeat action
                      },
                      icon: const Icon(
                        Icons.repeat,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Add logic for shuffle action
                      },
                      icon: const Icon(
                        Icons.shuffle,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.blue[800], // Background color of the drawer
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue[600], // Header background color
                ),
                child: const Text(
                  'Song Options',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Like Song',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Implement the logic for liking the song
                },
              ),
              ListTile(
                title: const Text(
                  'Dislike Song',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Implement the logic for disliking the song
                },
              ),
              ListTile(
                title: const Text(
                  'Show Lyrics',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  // Implement the logic for showing the lyrics of the song
                },
              ),
              const SizedBox(height: 16),

              // Rest of the options...
            ],
          ),
        ),
      ),
    );
  }
}
