import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_networking_app/utils/colors.dart';

import '../utils/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Image.asset("assets/logo.png"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.message_outlined)),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("posts").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemBuilder: (context, index) => PostCard(
                snap: snapshot.data?.docs[index].data(),
              ),
              itemCount: snapshot.data?.docs.length,
            );
          }),
    );
  }
}
