import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/Screens/home_screen.dart';
import 'package:music_player/Screens/search_screen.dart';
import 'package:music_player/Screens/user_infoo.dart';
import 'package:music_player/provider/mini_player_controller.dart';
import 'package:music_player/provider/user_provider.dart';
import 'package:music_player/widgets/mini_player.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
class MiniPlayerWrapper extends StatefulWidget {
  const MiniPlayerWrapper({super.key});

  @override
  State<MiniPlayerWrapper> createState() => _MiniPlayerWrapperState();
}

class _MiniPlayerWrapperState extends State<MiniPlayerWrapper> {
  PersistentTabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = PersistentTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    GetIt.I<AudioPlayer>().dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return  Scaffold(
                body: Stack(
                  children: [
                    PersistentTabView(
                      context,
                      controller: _tabController,
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
            
      },
    );
  }
}

List<Widget> _buildScreens() {
  return [
    const MyHomePage(),
    const SearchScreen(),
    userInfooo(
      uid: FirebaseAuth.instance.currentUser!.uid,
    )
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
