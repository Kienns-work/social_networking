import 'package:flutter/material.dart';
import 'package:social_networking_app/models/user.dart';
import 'package:social_networking_app/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  User? _user = User(
      email: "",
      uid: "",
      photoURL: "",
      username: "",
      bio: "",
      followers: [],
      following: []);

  User get getUser => _user!;

  final AuthMethod _authMethod = AuthMethod();

  Future<void> refreshUser() async {
    User user = await _authMethod.getCurrentUser();
    _user = user;
    print("địt con mẹ mày");

    notifyListeners();
  }
}
