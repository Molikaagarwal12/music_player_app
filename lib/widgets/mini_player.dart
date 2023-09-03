import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/utils/extensions.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../provider/mini_player_controller.dart';
import '../widgets/song_page.dart';

class GlobalMiniPlayer extends StatefulWidget {
  final Song song;
  final VoidCallback onClose;

  const GlobalMiniPlayer({
    Key? key,
    required this.song,
    required this.onClose,
  }) : super(key: key);

  @override
  State<GlobalMiniPlayer> createState() => GlobalMiniPlayerState();
}

class GlobalMiniPlayerState extends State<GlobalMiniPlayer> {
  bool replay = false;
  final AudioPlayer _player = GetIt.I<AudioPlayer>();

  

  void handleReplay() {
      setState(() {
        replay =true;
      });
      _player.seek(Duration.zero);
     _player.play();
    }
  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.black.withOpacity(0.9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              widget.song.image[2].link,
              fit: BoxFit.cover,
              width: 40,
              height: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.song.name.unescapeHtml(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  widget.song.primaryArtists.unescapeHtml(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            children: [
              FloatingActionButton(
                onPressed: () async {
                  Provider.of<MiniPlayerProvider>(context, listen: false)
                      .play(widget.song);
                },
                backgroundColor: Colors.grey,
                child: Icon(
                  Provider.of<MiniPlayerProvider>(context, listen: false)
                          .isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: Colors.black,
                  size: 36,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SongPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.open_in_new,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  Provider.of<MiniPlayerProvider>(context, listen: false)
                      .toggleMiniPlayerVisibility();
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  handleReplay();
                  setState(() {
                    replay = false;
                  }); // Call the replay function
                },
                icon: Icon(
                  Icons.replay,
                  color: replay
                      ? Colors.green
                      : Colors
                          .grey, // Change the icon color based on replay availability
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
