import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/Screens/home_screen.dart';
import 'package:music_player/Screens/search_screen.dart';
import 'package:music_player/provider/mini_player.dart';
import 'package:music_player/provider/mini_player_controller.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load();
  GetIt.I.registerSingleton<AudioPlayer>(AudioPlayer());

  runApp(
    ChangeNotifierProvider(
      create: (context) => MiniPlayerProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHome(),
      routes: {
        '/search': (context) => const SearchScreen(),
        '/home': (context) => const MyHomePage(),
        // Add other routes as needed
      },
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabs = [
      const MyHomePage(),
      const SearchScreen(),
      const Center(
        child: Text('User Profile'),
      ),
    ];

    const iconSize = 38.0;
    const tabBarHeight = 33.0;
    const miniPlayerBottom = tabBarHeight + iconSize / 2;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: tabs[_currentIndex],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                    icon: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                    },
                    icon: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: iconSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: miniPlayerBottom,
            left: 0,
            right: 0,
            child: Consumer<MiniPlayerProvider>(
              builder: (context, miniPlayerProvider, _) {
                if (miniPlayerProvider.isMiniPlayerVisible) {
                  return GlobalMiniPlayer(
                    song: miniPlayerProvider.currentSong!,
                    onClose: () {
                      miniPlayerProvider.toggleMiniPlayerVisibility();
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}







