// import 'package:flutter/material.dart';

// import 'package:music_player/Screens/search_screen.dart';

// import 'home_screen.dart';

// class TabsScreen extends StatefulWidget {
//   const TabsScreen({super.key});
//   @override
//   State<StatefulWidget> createState() {
//     return _TabsScreenState();
//   }
// }

// class _TabsScreenState extends State<TabsScreen> {
//   int _selectedPageIndex = 0;

//   void _pageselect(int index) {
//     setState(() {
//       _selectedPageIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget appScreen = const HomeScreen();
//     if (_selectedPageIndex == 1) {
//       appScreen = const SearchScreen();
//     }
//     return Scaffold(
//       body: appScreen,
//       bottomNavigationBar: BottomNavigationBar(
//         onTap: _pageselect,
//         currentIndex: _selectedPageIndex,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.search_rounded), label: "Search"),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.playlist_play), label: "PlayList"),
//         ],
//       ),
//     );
//   }
// }