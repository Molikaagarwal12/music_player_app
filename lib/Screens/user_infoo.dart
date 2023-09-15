import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_player/utils/image_picker.dart';

class userInfooo extends StatefulWidget {
  final String uid;

  const userInfooo({Key? key, required this.uid}) : super(key: key);

  @override
  State<userInfooo> createState() => _userInfoooState();
}

class _userInfoooState extends State<userInfooo> {
  bool isLoading = false;
  var userData = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data() ?? {};
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: const Text(
                'My Library',
                style: TextStyle(fontSize: 45, color: Colors.white),
              ),
              backgroundColor: Colors.black,
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(userData['photoUrl'] ?? ''),
                        radius: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: Text(
                          userData['userName'],
                          style: const TextStyle(color: Colors.white, fontSize: 35),
                        ),
                      )
                    ],
                  ),
                  Container(
                    
                  )
                ],
              ),
            )
            );
  }
}
