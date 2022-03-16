import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk/constants/color_constant.dart';
import 'package:ukk/view/Authentication/login/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final logOutButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: kRedColor,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(50),
          color: Colors.transparent,
          child: Center(
            child: MaterialButton(
              child: Text(
                "Add New Collection",
                textAlign: TextAlign.center,
                style: GoogleFonts.dongle(
                  fontSize: 28,
                  color: kWhiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () {
                _auth.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: kLightOrange2,
      appBar: AppBar(
        backgroundColor: kLightOrange,
        elevation: 2,
        title: Text(
          "Profile",
          style: GoogleFonts.dongle(
            fontSize: 28,
            color: kWhiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(),
    );
  }
}
