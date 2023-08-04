import 'package:flutter/material.dart';
import 'package:music_player/widgets/alubm_song_list.dart';
import '../api/jio_saavn.dart';
import '../widgets/playlist_song_details.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// ari maioya kaan fod die tumare laptop ki vplume h vo toh

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  const Text(
                    "Trending",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: trending.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          width: 150,
                          child: Card(
                            elevation: 4,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.network(
                                    trending[index].image[0].link,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    trending[index].name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Top Albums",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: albums.length,
                      itemBuilder: (context, index) {
                        final album = albums[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AlbumSongsPage(
                                  id: album.id,
                                  name: album.name,
                                ),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 150,
                            child: Card(
                              elevation: 4,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      album.image[0].link,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      album.name,
                                      overflow: TextOverflow.ellipsis,
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
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
                            width: 150,
                            child: Card(
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: charts.length,
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
                            width: 150,
                            child: Card(
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








//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
