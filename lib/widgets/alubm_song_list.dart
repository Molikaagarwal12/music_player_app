import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/api/jio_saavn.dart';
import 'package:music_player/utils/extensions.dart';
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
  late MiniPlayerProvider _miniPlayerController;

  @override
  void initState() {
    super.initState();
    _miniPlayerController = MiniPlayerProvider();
  }

  void _showMiniPlayer(Song song) {
    _miniPlayerController.play(song);
  }

  Widget _buildIconContainer({
    required IconData icon,
    required Color iconColor,
    required double iconSize,
    required double containerSize,
    required VoidCallback onTap,
  }) {
    return Container(
      width: containerSize,
      height: containerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }

  Widget _buildPlaylistControls() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildIconContainer(
            icon: Icons.favorite_border,
            iconColor: Colors.white,
            iconSize: 30,
            containerSize: 60,
            onTap: () {
              // Logic for the first icon's onTap function
            },
          ),
          const SizedBox(width: 10),
          _buildIconContainer(
            icon: Icons.play_arrow,
            iconColor: Colors.green,
            iconSize: 36,
            containerSize: 60,
            onTap: () {
              // Logic for the second icon's onTap function
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistDetails(Album playlist) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildPlaylistImage(playlist),
        const SizedBox(height: 20),
        _buildPlaylistControls(),
        const SizedBox(height: 10),
        _buildPlaylistNameAndYear(playlist),
        const SizedBox(height: 10),
        _buildAlbumInfo(playlist),
        const SizedBox(height: 15),
        _buildPlaylistInfo(playlist),
        const SizedBox(height: 15),
        Expanded(
          child: _buildSongList(playlist),
        ),
      ],
    );
  }

  Widget _buildPlaylistImage(Album playlist) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              playlist.image[2].link,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylistNameAndYear(Album playlist) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          playlist.name.unescapeHtml(),
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumInfo(Album playlist) {
    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "${playlist.primaryArtists}",
          style: const TextStyle(
              fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  Widget _buildPlaylistInfo(Album playlist) {
    String label = playlist.songs[0].label;
    // Truncate the label if its length exceeds a certain limit
    if (label.length > 14) {
      // Adjust the limit as needed
      label = '${label.substring(0, 14)}...'; // Truncate and add ellipsis
    }

    return Padding(
      padding: const EdgeInsets.only(left: 14),
      child: Row(
        children: [
          _buildIconContainer(
            icon: Icons.download_sharp,
            iconColor: Colors.white,
            iconSize: 20,
            containerSize: 40,
            onTap: () {
              // Logic for the download icon's onTap function
            },
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
                children: [
                  TextSpan(
                    text: "${playlist.year} • ",
                  ),
                  TextSpan(
                    text: "${playlist.songCount} songs • ",
                  ),
                  TextSpan(
                    text: label,
                    style: const TextStyle(), // Add your style here
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSongList(Album playlist) {
    return ListView.builder(
      itemCount: playlist.songs.length,
      itemBuilder: (context, index) {
        final song = playlist.songs[index];
        final artistName = song.primaryArtists;
        return _buildSongListItem(song, artistName);
      },
    );
  }

  Widget _buildSongListItem(Song song, String artistName) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      color: Colors.transparent, // Set the card color to transparent
      child: ListTile(
        leading: _buildSongImage(song),
        title: _buildSongTitle(song),
        subtitle: _buildArtistName(artistName),
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
          _miniPlayerController.showMiniPlayer();
          GetIt.I<AudioPlayer>().stop();
          _showMiniPlayer(song);
        },
      ),
    );
  }

  Widget _buildSongImage(Song song) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: Image.network(
        song.image[0].link,
        fit: BoxFit.cover,
        width: 60,
        height: 60,
      ),
    );
  }

  Widget _buildSongTitle(Song song) {
    return Text(
      song.name.unescapeHtml(),
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        color: Colors.white,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildArtistName(String artistName) {
    return Text(
      artistName.unescapeHtml(),
      style: const TextStyle(
        fontSize: 14.0,
        color: Colors.white70,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: api.getAlbumDetails(
          widget.albumId,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final album = snapshot.data as Album;

          return _buildPlaylistDetails(
            album,
          );
        },
      ),
    );
  }
}
