import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_networking_app/providers/user_provider.dart';
import 'package:social_networking_app/resources/firestore_methods.dart';
import 'package:social_networking_app/screens/comments_screen.dart';
import 'package:social_networking_app/utils/utils.dart';
import 'package:social_networking_app/widgets/like_animation.dart';

import '../models/user.dart';
import 'colors.dart';

class PostCard extends StatefulWidget {
  const PostCard({super.key, required this.snap});
  final snap;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLength = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCommentsLength();
  }

  getCommentsLength() async {
    var db = await FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.snap["postID"])
        .collection("comments")
        .get();
    commentLength = db.docs.length;
    setState(() {});
  }

  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: mobileBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap["profileImage"]),
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    widget.snap["username"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            shrinkWrap: true,
                            children: [
                              'Delete',
                            ]
                                .map(
                                  (e) => InkWell(
                                    onTap: () {
                                      FirestoreMethods()
                                          .deletePost(widget.snap["postID"]);
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.more_vert_outlined))
              ],
            ),
          ),

          //Ảnh đăng
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                widget.snap["postID"],
                user.uid,
                widget.snap["likes"],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.3, // MediaQuery.of(context).size.height trả về chiều cao của màn hình, nhân thêm 0.3 tức là sizedBox này = 30% chiều dài màn hình
                  width: double.infinity,
                  child: Image.network(
                    widget.snap["postURL"],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                      duration: const Duration(milliseconds: 400),
                      isAnimating: isLikeAnimating,
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 100,
                      )),
                )
              ],
            ),
          ),

          //Like, comment
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap["likes"].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                      widget.snap["postID"],
                      user.uid,
                      widget.snap["likes"],
                    );
                  },
                  icon: widget.snap["likes"].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : Icon(Icons.favorite_border_outlined),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentsScreen(snap: widget.snap),
                      ));
                },
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Transform.rotate(
                  angle: -45 * 3.14 / 180,
                  child: const Icon(
                    Icons.send,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bookmark_border,
                    ),
                  ),
                ),
              )
            ],
          ),

          // Mô tả, lượt thích, bình luận,...
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                  child: Text("${widget.snap["likes"].length} likes"),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(color: primaryColor),
                      children: [
                        TextSpan(
                          text: widget.snap["username"],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap["description"]}',
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CommentsScreen(snap: widget.snap))),
                      child: Text(
                        "View all $commentLength comments",
                        style: TextStyle(fontSize: 16, color: secondaryColor),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    '${caculateTimeDurationFromNow(widget.snap["datePublished"].toDate())}',
                    style: TextStyle(fontSize: 14, color: secondaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
