import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_networking_app/resources/auth_methods.dart';
import 'package:social_networking_app/utils/utils.dart';

import '../widgets/loading_button.dart';
import '../widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _userNameEditingController =
      TextEditingController();
  final TextEditingController _bioEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    _bioEditingController.dispose();
    _userNameEditingController.dispose();
  }

  selectImage() async {
    try {
      Uint8List image = await pickImage(ImageSource.gallery);
      setState(() {
        _image = image;
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: AssetImage("assets/blank-user.png"),
                      ),
                Positioned(
                    bottom: 10,
                    right: 10,
                    child: InkWell(
                        onTap: selectImage, child: Icon(Icons.add_a_photo)))
              ],
            ),
            SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintText: "Enter your username",
              textEditingController: _userNameEditingController,
            ),
            SizedBox(
              height: 20,
            ),
            TextFieldInput(
              hintText: "Enter your email",
              textInputType: TextInputType.emailAddress,
              textEditingController: _emailEditingController,
            ),
            SizedBox(
              height: 20,
            ),
            TextFieldInput(
              hintText: "Enter your password",
              isPassword: true,
              textEditingController: _passwordEditingController,
            ),
            SizedBox(
              height: 20,
            ),
            TextFieldInput(
              hintText: "Enter your bio",
              textEditingController: _bioEditingController,
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 18),
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: Colors.blue,
              ),
              width: double.infinity,
              child: InkWell(
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  var signUp = await AuthMethod().signUpUser(
                      email: _emailEditingController.text,
                      username: _userNameEditingController.text,
                      password: _passwordEditingController.text,
                      bio: _bioEditingController.text,
                      file: _image!);
                  setState(() {
                    _isLoading = false;
                  });
                },
                child: _isLoading
                    ? LoadingWidget()
                    : Text(
                        "Sign up",
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
