import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description, uid, username, postID, postURL, profileImage;
  final datePublished;
  final likes;

  Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.postID,
    required this.datePublished,
    required this.postURL,
    required this.profileImage,
    required this.likes,
  });
  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "username": username,
        "postID": postID,
        "datePublished": datePublished,
        "postURL": postURL,
        "profileImage": profileImage,
        "likes": likes
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        username: snapshot["username"],
        postID: snapshot["postID"],
        datePublished: snapshot["datePublished"],
        profileImage: snapshot["profileImage"],
        likes: snapshot["likes"],
        postURL: snapshot["postURL"]);
  }
}
