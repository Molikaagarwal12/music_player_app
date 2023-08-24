import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/api/jio_saavn.dart';
import 'package:music_player/utils/extensions.dart';
import 'package:provider/provider.dart'; // Import Provider
import '../models/playlist.dart';
import '../models/song.dart';
import '../provider/mini_player_controller.dart';

class PlaylistDetailPage extends StatefulWidget {
  final String playlistId;
  final String playlistTitle;

  PlaylistDetailPage({
    Key? key,
    required this.playlistId,
    required this.playlistTitle,
  }) : super(key: key);

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
  final MiniPlayerProvider miniPlayerController = MiniPlayerProvider();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
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
        future: api.getPlaylistDetails(widget.playlistId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final playlist = snapshot.data as Playlist;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 250),
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          playlist.image[2].link,
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
                            width: 2,
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
                            width: 2,
                          ),
                        ),
                        child: IconButton(
                          onPressed: () {
                            // Add your logic here for the second icon's onTap function
                          },
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.green,
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
                      playlist.name,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${playlist.songs[0].year}.${playlist.songs[0].album.name}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
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
                          ),
                          children: [
                            TextSpan(
                              text: "${playlist.songs.length} Songs",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: ' • '),
                            TextSpan(
                              text: "${playlist.followerCount} Fans",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: ' • '),
                            TextSpan(
                              text: playlist.songs[0].duration.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: playlist.songs.length,
                  itemBuilder: (context, index) {
                    final song = playlist.songs[index];
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
                            song.image[1].link,
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