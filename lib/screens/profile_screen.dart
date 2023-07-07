import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_networking_app/resources/auth_methods.dart';
import 'package:social_networking_app/resources/firestore_methods.dart';
import 'package:social_networking_app/screens/login_screen.dart';
import 'package:social_networking_app/utils/colors.dart';
import 'package:social_networking_app/utils/utils.dart';
import 'package:social_networking_app/widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.uid});
  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  bool isFollowing = false;
  int postNum = 0;
  String avatarURL = '';
  String username = '';
  String bio = '';
  int followers = 0, following = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      var userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      var postsSnapshot = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: widget.uid)
          .get();

      setState(() {
        bio = userSnapshot.data()!["bio"];
        username = userSnapshot.data()!["username"];
        avatarURL = userSnapshot.data()!["photoURL"];
        print(avatarURL);
        postNum = postsSnapshot.docs.length;
        followers = userSnapshot.data()!["followers"].length;
        following = userSnapshot.data()!["following"].length;
        isFollowing = userSnapshot
            .data()!["followers"]
            .contains(FirebaseAuth.instance.currentUser!.uid);
      });
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(username),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(avatarURL),
                      radius: 40,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildStatColumn(postNum, "Posts"),
                              buildStatColumn(followers, "Followers"),
                              buildStatColumn(following, "Following"),
                            ],
                          ),
                          FirebaseAuth.instance.currentUser!.uid == widget.uid
                              ? CustomButton(
                                  backgroundColor: mobileBackgroundColor,
                                  text: "Sign out",
                                  textColor: primaryColor,
                                  borderColor: Colors.grey,
                                  onPressed: () {
                                    AuthMethod().signOut();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                    );
                                  },
                                )
                              : isFollowing
                                  ? CustomButton(
                                      onPressed: () async {
                                        await FirestoreMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            widget.uid);

                                        setState(() {
                                          isFollowing = false;
                                          followers--;
                                        });
                                      },
                                      backgroundColor: mobileBackgroundColor,
                                      text: "Unfollow",
                                      textColor: primaryColor,
                                      borderColor: Colors.grey,
                                    )
                                  : CustomButton(
                                      onPressed: () async {
                                        await FirestoreMethods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            widget.uid);
                                        setState(() {
                                          isFollowing = true;
                                          followers++;
                                        });
                                      },
                                      backgroundColor: Colors.blue,
                                      text: "Follow",
                                      textColor: Colors.white,
                                      borderColor: Colors.blue,
                                    ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    username,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    bio,
                    style: TextStyle(),
                  ),
                )
              ],
            ),
          ),
          Divider(color: Colors.white, indent: 4),
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("posts")
                  .where("uid", isEqualTo: widget.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap = snapshot.data!.docs[index];

                      return Container(
                        child: Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                (snap.data()! as dynamic)["postURL"])),
                      );
                    });
              })
        ],
      ),
    );
  }

  Column buildStatColumn(int number, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          number.toString(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        )
      ],
    );
  }
}
