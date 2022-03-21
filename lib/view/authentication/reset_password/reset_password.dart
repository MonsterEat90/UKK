// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ukk/constants/color_constant.dart';
import 'package:ukk/view/authentication/signUp/signup.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  var email = "";

  final emailController = TextEditingController();

  @override
  void dispose() {
    //Clean up the controller when the widget is disposed.
    emailController.dispose();
    super.dispose();
  }

  //Resetting Password
  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: kPowderBlue,
        content: Text(
          'Password Reset Email has been sent',
          style: GoogleFonts.dongle(fontSize: 20),
        ),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found with that email');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: kPowderBlue,
            content: Text(
              'No user found with that email',
              style: GoogleFonts.dongle(fontSize: 20),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPowderBlue,
      appBar: AppBar(
        title: Text(
          "Forgot Password",
          style: GoogleFonts.dongle(
            fontSize: 40,
            color: kVeryDarkCyan,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kVeryDarkCyan,
          ),
          onPressed: () {
            //passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 180,
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 20),
            child: Text(
              'Reset Link will be sent to your email',
              style: GoogleFonts.dongle(fontSize: 25),
            ),
          ),
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 30,
                ),
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        autofocus: false,
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail),
                          labelText: 'Email',
                          labelStyle: GoogleFonts.dongle(fontSize: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                          errorStyle: GoogleFonts.dongle(
                            color: kRedColor,
                            fontSize: 15,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Email';
                          } else if (!value.contains('@')) {
                            return 'Please Enter Valid Email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(50),
                      elevation: 5,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: const LinearGradient(
                            colors: [kDarkModerateCyan, kModerateCyan],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.transparent,
                          child: Center(
                            child: MaterialButton(
                              child: Text(
                                "Send Email",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.dongle(
                                  fontSize: 28,
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
                              minWidth: MediaQuery.of(context).size.width,
                              onPressed: () {
                                // Validate returns true if the form is valid, otherwise false.
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    email = emailController.text;
                                  });
                                  resetPassword();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          child: Text(
                            "Register Now",
                            style: TextStyle(
                              color: kDarkModerateCyan,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
