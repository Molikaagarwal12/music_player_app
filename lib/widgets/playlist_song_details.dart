import 'package:flutter/material.dart';

import 'package:flutter_file_downloader/flutter_file_downloader.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/api/jio_saavn.dart';

import 'package:music_player/utils/extensions.dart';

import 'package:provider/provider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../models/playlist.dart';
import '../models/song.dart';
import '../provider/mini_player_controller.dart';

class PlaylistDetailPage extends StatefulWidget {
  final String playlistId;
  final String playlistTitle;

  const PlaylistDetailPage({
    Key? key,
    required this.playlistId,
    required this.playlistTitle,
  }) : super(key: key);

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  double? _progress;
  void _showMiniPlayer(Song song) {
    Provider.of<MiniPlayerProvider>(context, listen: false).play(song);
    print(song.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
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
                    Container(
                      constraints: const BoxConstraints(maxWidth: 250),
                      height: 250,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: IconButton(
                          onPressed: () {
                            // Add your logic here for the first icon's onTap function
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.heart,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: IconButton(
                          onPressed: () {
                            // Add your logic here for the second icon's onTap function
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.play,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            playlist.name,
                            speed: const Duration(milliseconds: 300),
                          ),
                        ],
                        totalRepeatCount: 80000,
                        pause: const Duration(milliseconds: 200),
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
                const SizedBox(
                  height: 10,
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
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          artistName.unescapeHtml(),
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: SizedBox(
                          width: 60,
                          child: Row(
                            children: [
                              Expanded(
                                child: IconButton(
                                  icon: const FaIcon(
                                    FontAwesomeIcons.download,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    FileDownloader.downloadFile(
                                        url: song.downloadUrl[0].link,
                                        name: song.name,
                                        onProgress: (fileName, progress) {
                                          setState(() {
                                            _progress = progress;
                                          });
                                        },
                                        onDownloadCompleted: (value) {
                                          print('path $value');
                                          setState(() {
                                            _progress = null;
                                          });
                                        });
                                  },
                                ),
                              ),
                              Expanded(
                                child: PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                  onSelected: (String value) {
                                    if (value == 'Show Lyrics') {
                                    } else if (value == 'Add to Queue') {
                                    } else if (value == 'Add to Favorite') {}
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    const PopupMenuItem<String>(
                                      value: 'Show Lyrics',
                                      child: Text('Add to Lyrics'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'Add to Queue',
                                      child: Text('Add to Queue'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'Add to Favorite',
                                      child: Text('Add to Favorite'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Provider.of<MiniPlayerProvider>(context,
                                  listen: false)
                              .setInfo(index, playlist.songs.length, playlist);
                          Provider.of<MiniPlayerProvider>(context,
                                  listen: false)
                              .showMiniPlayer();
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
