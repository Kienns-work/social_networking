import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:social_networking_app/providers/user_provider.dart';
import 'package:social_networking_app/utils/colors.dart';
import 'package:social_networking_app/utils/utils.dart';

import '../models/user.dart';
import '../resources/firestore_methods.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  bool isLoading = false;
  void postImage(String uid, String username, String profileImage) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _textEditingController.text,
        username,
        profileImage,
        _file!,
        uid,
      );
      setState(() {
        isLoading = false;
        _file = null;
        _textEditingController.clear();
      });
      showSnackBar(context, "😍 Posted!!");
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "😭 $err");
    }
  }

  TextEditingController _textEditingController = TextEditingController();
  _selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Text("Choose your photo"),
              children: [
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: Text("Take a photo"),
                  onPressed: () async {
                    Navigator.pop(context);
                    Uint8List file = await pickImage(ImageSource.camera);

                    setState(() {
                      _file = file;
                    });
                  },
                ),
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: Text("Choose from gallery"),
                  onPressed: () async {
                    Navigator.pop(context);
                    Uint8List file = await pickImage(ImageSource.gallery);

                    setState(() {
                      _file = file;
                    });
                  },
                ),
              ],
            ));
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text("Create post"),
        leading: Icon(Icons.arrow_back),
        actions: [
          TextButton(
              onPressed: () =>
                  postImage(user.uid, user.username, user.photoURL),
              child: Text(
                "Post",
                style: TextStyle(
                  fontSize: 20,
                  color: _file != null ? Colors.blue : Colors.grey,
                ),
              ))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              isLoading ? LinearProgressIndicator() : Container(),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user == null
                          ? "https://images2.thanhnien.vn/Uploaded/thanhlongn/2022_04_19/thuy-tien-6-3750.jpg"
                          : user.photoURL),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user == null ? "Your name ..." : user.username,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(.3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.public,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text("Public")
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
              TextField(
                minLines: 1,
                maxLines: 5,
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText:
                      "What's on your mind, ${user != null ? user.username : ""}?",
                  border: InputBorder.none,
                ),
              ),
              _file != null
                  ? Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: MemoryImage(_file!),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Add to your post",
                      style: TextStyle(fontSize: 20),
                    ),
                    Row(
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.photo_library_outlined,
                            color: Colors.green,
                            size: 30,
                          ),
                          onTap: () => _selectImage(context),
                        ),
                        InkWell(
                          child: Icon(
                            Icons.emoji_emotions_outlined,
                            color: Colors.yellow,
                            size: 30,
                          ),
                          onTap: () {},
                        ),
                        InkWell(
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 30,
                          ),
                          onTap: () {},
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
