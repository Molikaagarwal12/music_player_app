import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/playlist.dart';
import '../models/song.dart'; 

class FirebaseFavoriteMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSongToFavorites(String uid, Song song) async {
  try {
    DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
    List<dynamic> favoriteSongs = (snap.data()! as dynamic)['favoriteSongs'];
    if (favoriteSongs.contains(song.id)) {
      await _firestore.collection('users').doc(uid).update({
        'favoriteSongs': FieldValue.arrayRemove([song.id])
      });
    } else {
      await _firestore.collection('users').doc(uid).update({
        'favoriteSongs': FieldValue.arrayUnion([song.id])
      });
    }
  } catch (e) {
    print('Error adding/removing song to favorites: $e');
  }
}


  Future<void> createPlaylist(String userId, Playlist playlist) async {
  try {
    DocumentSnapshot snap = await _firestore.collection('users').doc(userId).get();
    List createdPlaylists = (snap.data()! as dynamic)['createdPlaylists'];
    if (createdPlaylists.contains(playlist.id)) {
      await _firestore.collection('users').doc(userId).collection('playlists').doc(playlist.id).delete();
      await _firestore.collection('users').doc(userId).update({
        'createdPlaylists': FieldValue.arrayRemove([playlist.id]),
      });
    } else {
      await _firestore.collection('users').doc(userId).collection('playlists').doc(playlist.id).set(playlist.toJson());
      await _firestore.collection('users').doc(userId).update({
        'createdPlaylists': FieldValue.arrayUnion([playlist.id]),
      });
    }
  } catch (e) {
    print('Error creating playlist: $e');
  }
}


}