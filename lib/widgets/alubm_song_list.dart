import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/api/jio_saavn.dart';
import 'package:music_player/utils/extensions.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../models/album.dart';

import '../models/song.dart';
import '../provider/mini_player_controller.dart';

class AlbumSongsPage extends StatefulWidget {
  final String albumId;
  final String albumTitle;

  const AlbumSongsPage({
    Key? key,
    required this.albumId,
    required this.albumTitle,
  }) : super(key: key);

  @override
  State<AlbumSongsPage> createState() => _AlbumSongsPageState();
}

class _AlbumSongsPageState extends State<AlbumSongsPage> {
  void _showMiniPlayer(Song song) {
    Provider.of<MiniPlayerProvider>(context, listen: false)
        .play(song); // Play the song using the provider
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: api.getAlbumDetails(widget.albumId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final album = snapshot.data as Album;
          String label = album.songs[0].label;
          if (label.length > 14) {
            label = '${label.substring(0, 14)}...';
          }
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          album.image[2].link,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Add your logic here for the first icon's onTap function
                          },
                          icon: const Icon(
                            Icons.favorite_border,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Add your logic here for the second icon's onTap function
                          },
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 36,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      album.name.unescapeHtml(),
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${album.primaryArtists}".unescapeHtml(),
                        style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      )),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Add your logic here for the first icon's onTap function
                          },
                          icon: const Icon(
                            Icons.download_sharp,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          children: [
                            TextSpan(
                              text: "${album.year} • ",
                            ),
                            TextSpan(
                              text: "${album.songCount} songs • ",
                            ),
                            TextSpan(
                              text: label,
                              style: const TextStyle(), // Add your style here
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: album.songs.length,
                  itemBuilder: (context, index) {
                    final song = album.songs[index];
                    final artistName = song.primaryArtists;
                    return Card(
                      color: Colors.black,
                      elevation: 2.0,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
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
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          artistName.unescapeHtml(),
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.download,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Logic for the download icon's onTap function
                          },
                        ),
                        onTap: () {
                          Provider.of<MiniPlayerProvider>(context,
                                  listen: false)
                              .showMiniPlayer(); // Show the mini player
                          GetIt.I<AudioPlayer>().stop();
                          _showMiniPlayer(song);
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

 // bottomNavigationBar: Consumer<MiniPlayerProvider>(
      //   builder: (context, miniPlayerProvider, child) {
      //     if (miniPlayerProvider.isMiniPlayerVisible) {
      //       return GlobalMiniPlayer(
      //         song: miniPlayerProvider.currentSong!,
      //         onClose: () {
      //           miniPlayerProvider.toggleMiniPlayerVisibility();
      //         },
      //       );
      //     } else {
      //       return const SizedBox.shrink();
      //     }
      //   },
      // ),