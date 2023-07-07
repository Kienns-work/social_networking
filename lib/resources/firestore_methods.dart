import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_networking_app/models/post.dart';
import 'package:social_networking_app/resources/storage_methods.dart';
import 'package:social_networking_app/utils/utils.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, String username,
      String profileImage, Uint8List file, String uid) async {
    String res = "Some errors occured";
    try {
      String photoURL =
          await StorageMethods().uploadImageToStorage("posts", file, true);
      String postID = Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postID: postID,
        datePublished: DateTime.now(),
        postURL: photoURL,
        profileImage: profileImage,
        likes: [],
      );

      _firestore.collection("posts").doc(postID).set(post.toJson());

      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  likePost(String postID, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection("posts").doc(postID).update({
          'likes': FieldValue.arrayRemove([
            uid
          ]), // Nếu tồn tại người dùng thì xóa người dùng khỏi danh sách
        });
      } else {
        await _firestore.collection("posts").doc(postID).update({
          'likes': FieldValue.arrayUnion([
            uid
          ]), // Nếu tồn tại người dùng thì xóa người dùng khỏi danh sách
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  postComment(String postID, String text, String uid, String name,
      String avatar) async {
    try {
      if (text.isNotEmpty) {
        String commentID = Uuid().v1();
        await _firestore
            .collection("posts")
            .doc(postID)
            .collection("comments")
            .doc(commentID)
            .set({
          "avatar": avatar,
          "postID": postID,
          "text": text,
          "uid": uid,
          "name": name,
          "datePublished": DateTime.now(),
        });
      } else {
        print("Text is empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postID) async {
    try {
      await FirebaseFirestore.instance.collection("posts").doc(postID).delete();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> followUser(String uid, String followID) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection("users").doc(uid).get();
      List following = (snap.data()! as dynamic)["following"];

      if (following.contains(followID)) {
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayRemove([uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followID]),
        });

        print("gỡ xong follow");
      } else {
        await _firestore.collection('users').doc(followID).update({
          'followers': FieldValue.arrayUnion([uid]),
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followID]),
        });
        print("follow người ta");
      }
    } catch (err) {
      print(err.toString() + "lolmeno");
    }
  }
}
