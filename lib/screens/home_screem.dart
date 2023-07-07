import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_networking_app/models/user.dart' as model;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_networking_app/providers/user_provider.dart';
import 'package:social_networking_app/utils/colors.dart';
import '../utils/global_variables.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 0;
  String username = "";
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("bắt đầu chạy reFreshUser");
    refreshCurrentUser();
    print("Chạy xong rồi");
    _pageController = PageController();
  }

  // void getCurrentUsername() async {
  //   DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   print("snapshot.data");
  //   print(snapshot.data());

  //   setState(() {
  //     username = (snapshot.data() as Map<String, dynamic>)["username"];
  //   });
  // }
  refreshCurrentUser() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    print("bắt đầu tới userProvider...");
    await userProvider.refreshUser();
    print("chạy xong userProvider rồi.");
  }

  void nextPage(int nextPage) {
    _pageController.jumpToPage(nextPage);
  }

  void onPageChanged(int number) {
    setState(() {
      page = number;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: itemHomeScreen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        elevation: 10,
        currentIndex: page,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: page == 0 ? 35 : 30,
              color: page == 0 ? primaryColor : secondaryColor,
            ),
            label: "",
            backgroundColor: mobileBackgroundColor,
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: page == 1 ? 35 : 30,
                color: page == 1 ? primaryColor : secondaryColor,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                size: page == 2 ? 35 : 30,
                color: page == 2 ? primaryColor : secondaryColor,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                size: page == 3 ? 35 : 30,
                color: page == 3 ? primaryColor : secondaryColor,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: page == 4 ? 35 : 30,
                color: page == 4 ? primaryColor : secondaryColor,
              ),
              label: ""),
        ],
        onTap: nextPage,
      ),
    );
  }
}
