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
import 'package:music_player/Screens/user_infoo.dart';
import 'package:music_player/provider/mini_player_controller.dart';
import 'package:music_player/provider/user_provider.dart';

import 'package:music_player/widgets/mini_player_wrapper.dart';
import 'package:provider/provider.dart';


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
          '/user': (context) => userInfooo(
                uid: FirebaseAuth.instance.currentUser!.uid,
              )
        },
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
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
        ));
  }
}
