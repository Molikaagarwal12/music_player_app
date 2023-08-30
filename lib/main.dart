import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/Screens/home_screen.dart';
import 'package:music_player/Screens/login_screen.dart';
import 'package:music_player/Screens/search_screen.dart';
import 'package:music_player/Screens/signup_screen.dart';
import 'package:music_player/provider/mini_player_controller.dart';
import 'package:music_player/provider/user_provider.dart';
import 'package:music_player/widgets/mini_player.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  await dotenv.load();
  GetIt.I.registerSingleton<AudioPlayer>(AudioPlayer());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MiniPlayerProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
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
      routes: {
        '/search': (context) => const SearchScreen(),
        '/home': (context) => const MyHomePage(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              print("pehle se hai data");
              return const MiniPlayerWrapper();
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            }
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          return const LoginScreen();
        },
      ),
    );
  }
}

class MiniPlayerWrapper extends StatelessWidget {
  const MiniPlayerWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PersistentTabView(
            context,
            controller: PersistentTabController(initialIndex: 0),
            screens: _buildScreens(),
            items: _navBarsItems(),
            confineInSafeArea: true,
            backgroundColor: Colors.black.withOpacity(0.0),
          ),
          Positioned(
            bottom: 62,
            left: 0,
            right: 0,
            child: Consumer<MiniPlayerProvider>(
              builder: (context, miniPlayerProvider, _) {
                if (miniPlayerProvider.isMiniPlayerVisible) {
                  // Replace with your mini player widget
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

List<Widget> _buildScreens() {
  return [
    const MyHomePage(),
    const SearchScreen(),
    const Center(
      child: Text('User Profile'),
    ),
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.home),
      title: ("Home"),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.white,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.search),
      title: ("Search"),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.white,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.person),
      title: ("Profile"),
      activeColorPrimary: Colors.white,
      inactiveColorPrimary: Colors.white,
    ),
  ];
}

