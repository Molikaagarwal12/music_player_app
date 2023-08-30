import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String userName; 
  final String photoUrl;
  final List<String> favoriteSongs;
  final List<String> favoritePlaylists;

  User({
    required this.photoUrl,
    required this.uid,
    required this.email,
    required this.userName,
    required this.favoriteSongs,
    required this.favoritePlaylists,
  });

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "favoriteSongs": favoriteSongs,
        "favoritePlaylists": favoritePlaylists,
      };

  static User fromsnap(DocumentSnapshot snap) {
    var snapShot = snap.data() as Map<String, dynamic>;
    print(snapShot);
    return User(
      userName: snapShot['userName'],
      uid: snapShot['uid'],
      email: snapShot['email'],
      photoUrl: snapShot['photoUrl'],
      favoriteSongs: List<String>.from(snapShot['favoriteSongs'] ?? []),
      favoritePlaylists: List<String>.from(snapShot['favoritePlaylists'] ?? []),
    );
  }
}
