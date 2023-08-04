class User {
  final String uid;
  final String username;
  final String email;
  final List<String> likedSongs;
  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.likedSongs,
  });
}
