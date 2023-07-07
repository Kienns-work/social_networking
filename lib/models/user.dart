import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email, uid, photoURL, username, bio;
  final List followers;
  final List following;

  User({
    required this.email,
    required this.uid,
    required this.photoURL,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });
  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "email": email,
        "bio": bio,
        "followers": [],
        "following": [],
        "photoURL": photoURL
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot["username"],
      bio: snapshot["bio"],
      email: snapshot["email"],
      uid: snapshot["uid"],
      photoURL: snapshot["photoURL"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }
}
