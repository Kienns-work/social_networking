import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_networking_app/models/user.dart' as model;
import 'package:social_networking_app/resources/storage_methods.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getCurrentUser() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot =
        await _firestore.collection("users").doc(currentUser.uid).get();

    return model.User.fromSnap(snapshot);
  }

  Future<String> signUpUser(
      {required String email,
      required String username,
      required String password,
      required String bio,
      required Uint8List file}) async {
    String res = "Some errors occured";
    try {
      if (email.isNotEmpty ||
          username.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty) {
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String photoURL = await StorageMethods()
            .uploadImageToStorage("ProfilePics", file, false);

        model.User user = model.User(
            bio: bio,
            email: email,
            followers: [],
            following: [],
            uid: userCred.user!.uid,
            photoURL: photoURL,
            username: username);

        await _firestore
            .collection("users")
            .doc(userCred.user!.uid)
            .set(user.toJson());

        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({required email, required password}) async {
    String res = "Some errors occurs";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        print("Please fill input");
      }
    } catch (err) {
      res = err.toString();
      print(err);
    }

    return res;
  }

  signOut() async {
    await _auth.signOut();
  }
}
