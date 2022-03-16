// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ukk/constants/color_constant.dart';
import 'package:ukk/model/navbar.dart';
import 'package:ukk/view/authentication/reset_password/reset_password.dart';
import 'package:ukk/view/authentication/signUp/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = true;
  //Form Key
  final _formKey = GlobalKey<FormState>();

  var email = "";
  var password = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  clearText() {
    emailController.clear();
    passwordController.clear();
  }

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PageNavBar(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No User Found for that Email");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        print("Wrong Password Provided by User");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //Email Field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter Email';
        } else if (!value.contains('@')) {
          return 'Please Enter Valid Email';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.mail),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    //Password Field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      obscureText: _passwordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter Password';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon:
              Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );
    final loginButton = Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(
            colors: const [kDarkModerateCyan, kModerateCyan],
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
                "Login",
                textAlign: TextAlign.center,
                style: GoogleFonts.dongle(
                  fontSize: 30,
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
                    password = passwordController.text;
                  });
                  userLogin();
                }
              },
            ),
          ),
        ),
      ),
    );
    final forgotPassword = Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPassword(),
            ),
          ),
        },
        child: Text(
          'Forgot Password ?',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.grey,
          ),
        ),
      ),
    );
    final registerNow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.grey),
        ),
        GestureDetector(
          child: Text(
            "Register Now",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpPage(),
              ),
            );
          },
        ),
      ],
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      decoration: BoxDecoration(
                        color: kWhiteColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100),
                        ),
                        gradient: LinearGradient(
                          colors: [kDarkModerateCyan, kModerateCyan],
                          stops: [0.0, 1],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 60,
                          ),
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: SvgPicture.asset(
                              'assets/logo.svg',
                              fit: BoxFit.contain,
                              color: kWhiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            height: 70,
                          ),
                          emailField,
                          SizedBox(
                            height: 20,
                          ),
                          passwordField,
                          SizedBox(
                            height: 20,
                          ),
                          forgotPassword,
                          SizedBox(
                            height: 30,
                          ),
                          loginButton,
                          SizedBox(
                            height: 60,
                          ),
                          registerNow,
                        ],
                      ),
                    ),
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
