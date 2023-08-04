import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/api/jio_saavn.dart';
import 'package:music_player/utils/extensions.dart';
import 'package:music_player/widgets/song_page.dart';

import '../models/song.dart';

class PlaylistDetailPage extends StatefulWidget {
  final String playlistId;
  final String playlistTitle;

  const PlaylistDetailPage(
      {super.key, required this.playlistId, required this.playlistTitle});

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.playlistTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: api.getPlaylistDetails(widget.playlistId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final playlist = snapshot.data!;

          return ListView.builder(
            itemCount: playlist.songs.length,
            itemBuilder: (context, index) {
              final song = playlist.songs[index];
              final artistName = song.primaryArtists;
              return Card(
                elevation: 2.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.network(
                      song.image[2].link,
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  ),
                  title: Text(
                    song.name.unescapeHtml(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    artistName.unescapeHtml(),
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    player.stop();
                    _player(context, song, player);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _player(BuildContext context, Song song, AudioPlayer player) {
    showBottomSheet(
      context: context,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.15,
        maxChildSize: 0.15,
        minChildSize: 0.15,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            children: [
              ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    song.image[2].link,
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                ),
                title: Text(
                  song.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                subtitle: Text(
                  song.primaryArtists,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SongPage(
                        song: song,
                        player: player,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
