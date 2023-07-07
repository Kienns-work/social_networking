import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_networking_app/screens/add_post_screen.dart';
import 'package:social_networking_app/screens/feed_screen.dart';
import 'package:social_networking_app/screens/profile_screen.dart';
import 'package:social_networking_app/screens/search_screen.dart';

List<Widget> itemHomeScreen = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(child: Text("Favorite")),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
