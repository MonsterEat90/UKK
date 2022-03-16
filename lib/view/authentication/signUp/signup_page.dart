// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ukk/constants/color_constant.dart';
import 'package:ukk/view/authentication/login/login_page.dart';
import 'package:path/path.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool loading = false;
  bool _passwordVisible = true;
  //Form Key
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final _picker = ImagePicker();
  String url = "";
  final collectionNameController = TextEditingController();

  var email = "";
  var password = "";
  var confirmPassword = "";

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  uploadImage() async {
    var imageFile = FirebaseStorage.instance
        .ref()
        .child("collectionImage")
        .child(basename(_image!.path));
    UploadTask task = imageFile.putFile(_image!);
    TaskSnapshot snapshot = await task;
    //for download
    url = await snapshot.ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('collection').doc().set({
      'imageUrl': url,
      'collectionName': collectionNameController.text,
    });
    print(url);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  clearText() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  Future getImageFromGallery() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    final File image = File(pickedFile!.path);
    setState(() {
      _image = image;
    });
  }

  passwordRegistration() async {
    if (password == confirmPassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        print(userCredential);
        ScaffoldMessenger.of(this.context).showSnackBar(
          SnackBar(
            backgroundColor: kSoftLimeGreen,
            content: Text(
              "Registered Successfully. Please Login..",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        );
        Navigator.pushReplacement(
          this.context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print("Password Provided is too Weak");
          ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(
              backgroundColor: kLightOrange,
              content: Text(
                "Password Provided is too Weak",
                style: GoogleFonts.dongle(fontSize: 18.0, color: kBlackColor),
              ),
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          print("Account Already exists");
          ScaffoldMessenger.of(this.context).showSnackBar(
            SnackBar(
              backgroundColor: kLightOrange,
              content: Text(
                "Account Already exists",
                style: GoogleFonts.dongle(fontSize: 18.0, color: kBlackColor),
              ),
            ),
          );
        }
      }
    } else {
      print("Password and Confirm Password doesn't match");
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          backgroundColor: kLightOrange,
          content: Text(
            "Password and Confirm Password doesn't match",
            style: GoogleFonts.dongle(fontSize: 16.0, color: kBlackColor),
          ),
        ),
      );
    }
  }

  // Adding User to Cloud Firestore
  Future _signUp() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await FirebaseFirestore.instance.collection('user').add({
        'email': emailController.text,
        'password': passwordController.text,
        'confirmPassword': confirmPasswordController.text,
        'imageUrl': url,
        'name': '',
        'phoneNumber': '',
      });
      await showDialog(
        context: this.context,
        builder: (context) => AlertDialog(
          title: Text('Sign Up Successful'),
          content: Text('Your account was created, you can now login'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      _handleSignUpError(e);
      setState(() {
        loading = false;
      });
    }
  }

  void _handleSignUpError(FirebaseAuthException e) {
    String messageToDisplay;
    switch (e.code) {
      case 'email-already-in-use':
        messageToDisplay = 'The email is already in use';
        break;
      case 'invalid-email':
        messageToDisplay = 'The email is invalid';
        break;
      case 'operation-not-allowed':
        messageToDisplay = 'This operation is not allowed';
        break;
      case 'weak-password':
        messageToDisplay = 'The password is not strong enough';
        break;
      default:
        messageToDisplay = 'An undefined error occurred';
        break;
    }

    showDialog(
      context: this.context,
      builder: (context) => AlertDialog(
        title: Text('Sign Up Failed'),
        content: Text(messageToDisplay),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
  // CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Future<void> addUser() {
  //   return users
  //       .add({
  //         'email': email,
  //         'password': password,
  //         'confirmPassword': confirmPassword,
  //       })
  //       .then((value) => print('User Added'))
  //       .catchError((error) => print('Failed to Add user: $error'));
  // }

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
    //Confirm Password
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordController,
      obscureText: _passwordVisible,
      validator: (value) {
        if (confirmPasswordController.text != passwordController.text) {
          return "Confirm Password doesn't match";
        }
        return null;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.vpn_key),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
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
    //Sign Up Button
    final signUpButton = Material(
      elevation: 5,
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
                "SignUp",
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
                    password = passwordController.text;
                    confirmPassword = confirmPasswordController.text;
                    // addUser();
                    passwordRegistration();
                    uploadImage();
                    _signUp();
                    clearText();
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
    //Reset Button
    final resetButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: kSecondaryColor,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(50),
          color: Colors.transparent,
          child: Center(
            child: MaterialButton(
              child: Text(
                "Reset",
                textAlign: TextAlign.center,
                style: GoogleFonts.dongle(
                  fontSize: 28,
                  color: kWhiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () => {clearText()},
            ),
          ),
        ),
      ),
    );

    final alreadyMember = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Already a Member? ",
          style: TextStyle(color: Colors.grey),
        ),
        GestureDetector(
          child: Text(
            "Login Now",
            style: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          onTap: () {
            Navigator.of(context).pop();
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
                          colors: const [kDarkModerateCyan, kModerateCyan],
                          stops: [0.0, 1.0],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
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
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              getImageFromGallery();
                            },
                            child: CircleAvatar(
                              radius: 100,
                              backgroundColor: kWhiteColor,
                              backgroundImage: _image == null
                                  ? AssetImage("")
                                  : FileImage(File(_image!.path))
                                      as ImageProvider,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          emailField,
                          SizedBox(
                            height: 10,
                          ),
                          passwordField,
                          SizedBox(
                            height: 10,
                          ),
                          confirmPasswordField,
                          SizedBox(
                            height: 30,
                          ),
                          signUpButton,
                          SizedBox(
                            height: 10,
                          ),
                          resetButton,
                          SizedBox(
                            height: 50,
                          ),
                          alreadyMember,
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
