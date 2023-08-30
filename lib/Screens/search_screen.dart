import 'package:flutter/material.dart';
import 'package:music_player/Screens/login_screen.dart';
import 'package:music_player/resources/auth_repo.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: TextButton(
          onPressed: () async{ 
          await AuthRepo().signOut();
          if(context.mounted){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const LoginScreen()));
          }
           },
          child: const Text("SignOut",style: TextStyle(color: Colors.black,fontSize: 60),),

        )
        

        ),
    
    );
  }
}