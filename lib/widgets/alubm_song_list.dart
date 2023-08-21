import 'package:flutter/material.dart';
import 'package:music_player/api/jio_saavn.dart';
import 'package:provider/provider.dart';
import '../models/album.dart';
import '../models/song.dart';

import '../provider/mini_player_controller.dart';

class AlbumSongsPage extends StatefulWidget {
  final String id;
  final String name;

  const AlbumSongsPage({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<AlbumSongsPage> createState() => _AlbumSongsPageState();
}

class _AlbumSongsPageState extends State<AlbumSongsPage> {
  void _showMiniPlayer(Song song) {
    Provider.of<MiniPlayerProvider>(context, listen: false).play(song);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<Album>(
        future: api.getAlbumDetails(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("No data available."),
            );
          }

          final album = snapshot.data!;

          return ListView.builder(
            itemCount: album.songs.length,
            itemBuilder: (context, index) {
              final song = album.songs[index];
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
                    song.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Text(
                    artistName,
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  onTap: () {
                    Provider.of<MiniPlayerProvider>(context, listen: false)
                        .showMiniPlayer();
                    _showMiniPlayer(song);
                  },
                ),
              );
            },
          );
        },
      ),
      
    );
  }
}
