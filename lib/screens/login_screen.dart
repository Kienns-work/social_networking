import 'package:flutter/material.dart';
import 'package:social_networking_app/resources/auth_methods.dart';
import 'package:social_networking_app/screens/signup_screen.dart';
import 'package:social_networking_app/widgets/loading_button.dart';
import '../widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethod().loginUser(
        email: _emailEditingController.text,
        password: _passwordEditingController.text);
    setState(() {
      _isLoading = false;
    });
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
            Image.asset("assets/logo.png"),
            SizedBox(
              height: 24,
            ),
            TextFieldInput(
              inputBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              hintText: "Enter your email",
              isPassword: false,
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
              child: _isLoading
                  ? LoadingWidget()
                  : InkWell(
                      onTap: loginUser,
                      child: Text(
                        "Login",
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account ? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupScreen()));
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
