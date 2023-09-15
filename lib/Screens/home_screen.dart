import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

import 'package:music_player/provider/mini_player_controller.dart';
import 'package:music_player/utils/extensions.dart';
import 'package:music_player/widgets/alubm_song_list.dart';
import 'package:provider/provider.dart';
import '../api/jio_saavn.dart';
import '../models/song.dart';
import '../widgets/playlist_song_details.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _showMiniPlayer(Song song) {
    print("object");
    Provider.of<MiniPlayerProvider>(context, listen: false).play(song);
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future:
            api.getHomeData(langs: ["hindi", "spanish", "english", "punjabi"]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            final trending = snapshot.data!.trending.albums;
            final albums = snapshot.data!.albums;
            final playlists = snapshot.data!.playlists;
            final charts = snapshot.data!.charts;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Text(
                    getGreeting(),
                    style: const TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.black,
                        fontSize: 27),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    "Trending",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: trending.length,
                      itemBuilder: (context, index) {
                        final trending_ = trending[index];
                        return GestureDetector(
                          onTap: () async {
                            if (trending_.type == "album") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AlbumSongsPage(
                                    albumId: trending_.id,
                                    albumTitle: trending_.name,
                                  ),
                                ),
                              );
                            } else {
                              final miniPlayerProvider =
                                  Provider.of<MiniPlayerProvider>(context,
                                      listen: false);

                              miniPlayerProvider.setLoadingState(true);

                              final song =
                                  await api.getSongDetails(trending_.id);

                              if (context.mounted) {
                                Provider.of<MiniPlayerProvider>(context,
                                        listen: false)
                                    .setInfo(index, 1, trending_);
                                miniPlayerProvider.setLoadingState(false);
                                Provider.of<MiniPlayerProvider>(context,
                                        listen: false)
                                    .showMiniPlayer(); // Show the mini player
                                GetIt.I<AudioPlayer>().stop();
                                _showMiniPlayer(song[0]);
                              }
                            }
                          },
                          child: SizedBox(
                            width: 180,
                            child: Card(
                              color: Colors.black,
                              elevation: 4,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      trending[index].image[1].link,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      trending[index].name.unescapeHtml(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Top Albums",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: albums.length,
                      itemBuilder: (context, index) {
                        final album = albums[index];
                        return GestureDetector(
                          onTap: () async {
                            if (album.type == "album") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AlbumSongsPage(
                                    albumId: album.id,
                                    albumTitle: album.name,
                                  ),
                                ),
                              );
                            } else {
                              final miniPlayerProvider =
                                  Provider.of<MiniPlayerProvider>(context,
                                      listen: false);

                              miniPlayerProvider.setLoadingState(true);

                              final song = await api.getSongDetails(album.id);

                              if (context.mounted) {
                                Provider.of<MiniPlayerProvider>(context,
                                        listen: false)
                                    .setInfo(index, 1, song);
                                miniPlayerProvider.setLoadingState(false);
                                Provider.of<MiniPlayerProvider>(context,
                                        listen: false)
                                    .showMiniPlayer();
                                GetIt.I<AudioPlayer>().stop();
                                _showMiniPlayer(song[0]);
                              }
                            }
                          },
                          child: SizedBox(
                            width: 180,
                            child: Card(
                              color: Colors.black,
                              elevation: 4,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      album.image[2].link,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      album.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Top Playlists",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: playlists.length,
                      itemBuilder: (context, index) {
                        final playlist = playlists[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlaylistDetailPage(
                                    playlistId: playlist.id,
                                    playlistTitle: playlist.title),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 180,
                            child: Card(
                              color: Colors.black,
                              elevation: 4,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      playlist.image[0].link,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      playlist.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Top Charts",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: playlists.length,
                      itemBuilder: (context, index) {
                        final chart = charts[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlaylistDetailPage(
                                    playlistId: chart.id,
                                    playlistTitle: chart.title),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 180,
                            child: Card(
                              color: Colors.black,
                              elevation: 4,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      chart.image[0].link,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      chart.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
