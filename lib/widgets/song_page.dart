// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/song.dart';

class SongPage extends StatefulWidget {
  final Song song;
  final AudioPlayer player;

  const SongPage({
    Key? key,
    required this.song,
    required this.player,
  }) : super(key: key);

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  double sliderValue = 0.0;
  bool isLiked = false;
  Duration? totalDuration;
  bool isSliderChanging = false;
  bool isPlaying = false;
  Duration? lastPosition;

  Duration parseDuration(String? durationString) {
    if (durationString == null || durationString.isEmpty) {
      return Duration.zero;
    }
    final parts = durationString.split(":");
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      return Duration(minutes: minutes, seconds: seconds);
    } else if (parts.length == 3) {
      final hours = int.tryParse(parts[0]) ?? 0;
      final minutes = int.tryParse(parts[1]) ?? 0;
      final seconds = int.tryParse(parts[2]) ?? 0;
      return Duration(hours: hours, minutes: minutes, seconds: seconds);
    } else {
      return Duration.zero;
    }
  }

  @override
  void initState() {
    super.initState();

    final durationString = widget.song.duration;
    final parsedDuration = parseDuration(durationString);
    setState(() {
      totalDuration = parsedDuration;
    });
    widget.player.setUrl(widget.song.downloadUrl[2].link).then((_) {
      setState(() {
        totalDuration = widget.player.duration ?? Duration.zero;
      });
    });
    widget.player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          sliderValue = 0.0;
          isPlaying = false;
        });
      }
    });

    widget.player.positionStream.listen((event) {
      setState(() {
        sliderValue = event.inSeconds.toDouble();
      });
    });
  }

  @override
  void dispose() {
    widget.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 120), // Spacer for the image

                Text(
                  widget.song.name,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Album: ${widget.song.album.name}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Artist: ${widget.song.primaryArtists}',
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
                          setState(() {
                            isPlaying = !isPlaying;
                          });
                          try {
                            if (!isPlaying) {
                              await widget.player.pause();
                              lastPosition = widget.player.position;
                            } else {
                              if (lastPosition != null) {
                                await widget.player.seek(lastPosition);
                                await widget.player.play();
                              } else {
                                await widget.player
                                    .setUrl(widget.song.downloadUrl[2].link);
                                await widget.player.play();
                              }
                            }
                          } catch (e) {
                            print("Error: $e");
                          }
                        },
                        backgroundColor: Colors.white,
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
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
                  max: (totalDuration?.inSeconds.toDouble() ?? 0.0),
                  onChanged: (value) {
                    setState(() {
                      sliderValue = value;
                    });
                  },
                  onChangeEnd: (value) async {
                    final position = Duration(seconds: value.toInt());
                    await widget.player.seek(position);
                    if (isPlaying) {
                      await widget.player.play();
                    }
                  },
                  value: sliderValue,
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey[600],
                ),

                const SizedBox(height: 32),

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
