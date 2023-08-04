import 'package:flutter/material.dart';
import 'package:music_player/api/jio_saavn.dart';

class AlbumSongsPage extends StatefulWidget {
  final String id;
  final String name;

  const AlbumSongsPage({super.key, required this.id, required this.name});

  @override
  State<AlbumSongsPage> createState() => _AlbumSongsPageState();
}

class _AlbumSongsPageState extends State<AlbumSongsPage> {
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
      body: FutureBuilder(
        future: api.getAlbumDetails(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final album = snapshot.data;

          return ListView.builder(
            itemCount: album?.songs.length ?? 0,
            itemBuilder: (context, index) {
              final song = album?.songs[index];
              final artistName = song?.primaryArtists ?? "Unknown Artist";
              return Card(
                elevation: 2.0,
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Image.network(
                      song?.image[2].link ?? "",
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  ),
                  title: Text(
                    song?.name ?? "Unknown Song",
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
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
