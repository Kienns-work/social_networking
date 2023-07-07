import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_networking_app/providers/user_provider.dart';
import 'package:social_networking_app/resources/firestore_methods.dart';
import 'package:social_networking_app/utils/colors.dart';
import '../models/user.dart';
import '../widgets/comment_card.dart';

class CommentsScreen extends StatelessWidget {
  CommentsScreen({super.key, required this.snap});
  final snap;
  TextEditingController textCommentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("Comments"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("posts")
              .doc(snap["postID"])
              .collection("comments")
              .orderBy("datePublished", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => CommentCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            );
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(user.photoURL),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: textCommentController,
                    decoration: InputDecoration(
                      hintText: "Add a comment",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  FirestoreMethods().postComment(
                      snap["postID"],
                      textCommentController.text,
                      snap["uid"],
                      snap["username"],
                      snap["profileImage"]);
                  textCommentController.clear();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
