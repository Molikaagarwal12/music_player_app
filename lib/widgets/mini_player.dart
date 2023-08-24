import 'package:flutter/material.dart';
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
            // Use Expanded to ensure the column takes available space
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
                      builder: (context) => SongPage(
                        song: widget.song,
                      ),
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
            ],
          ),
        ],
      ),
    );
  }
}
