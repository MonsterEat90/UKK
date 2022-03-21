import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ukk/constants/color_constant.dart';
import 'package:path/path.dart';
import 'package:ukk/model/already_member.dart';
import 'package:ukk/model/button/reset_button.dart';
import 'package:ukk/model/button/signup_button.dart';
import 'package:ukk/model/text_field/confirm_password_field.dart';
import 'package:ukk/model/text_field/email_field.dart';
import 'package:ukk/model/text_field/name_field.dart';
import 'package:ukk/model/text_field/password_field.dart';
import 'package:ukk/model/text_field/phone_number_field.dart';
import 'package:ukk/view/authentication/login/login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //Text Editing Controller
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var name = "";
  var phoneNumber = "";
  var email = "";
  var password = "";
  var confirmPassword = "";

  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  File? _image;
  String url = "";

  clearText() {
    nameController.clear();
    phoneNumberController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  Future getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    final File image = File(pickedFile!.path);
    setState(() {
      _image = image;
    });
  }

  uploadImage() async {
    //upload the image to storage
    var imageFile = FirebaseStorage.instance
        .ref()
        .child("usersProfilePic")
        .child(basename(_image!.path));
    UploadTask task = imageFile.putFile(_image!);
    TaskSnapshot snapshot = await task;
    //for download
    url = await snapshot.ref.getDownloadURL();
    print(url);
    return url;
  }

  //add user to firebase
  addUserToFirebase() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print(value.user!.uid);
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(
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
          builder: (context) => const LoginPage(),
        ),
      );
    });
    //add user to firestore
    await FirebaseFirestore.instance.collection('users').doc().set({
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'imageProfileUrl': url,
    });

    // await FirebaseFirestore.instance.collection('users').doc().set({
    //   'name': name,
    //   'phoneNumber': phoneNumber,
    //   'email': email,
    //   'password': password,
    //   'confirmPassword': confirmPassword,
    //   'imageProfileUrl': url,
    // });
  }

  @override
  Widget build(BuildContext context) {
    final fileName =
        _image != null ? basename(_image!.path) : 'No Image Selected';
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: kPowderBlue,
        body: Form(
          key: _formKey,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 45),
                          InkWell(
                            onTap: () {
                              getImageFromGallery();
                            },
                            child: CircleAvatar(
                              radius: 80,
                              backgroundColor: kDarkModerateCyan,
                              backgroundImage: _image == null
                                  ? const AssetImage("profile image")
                                  : FileImage(File(_image!.path))
                                      as ImageProvider,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            fileName,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                          NameField(inputController: nameController),
                          const SizedBox(height: 10),
                          PhoneNumberField(
                              inputController: phoneNumberController),
                          const SizedBox(height: 10),
                          EmailField(inputController: emailController),
                          const SizedBox(height: 10),
                          PasswordField(inputController: passwordController),
                          const SizedBox(height: 10),
                          ConfirmPasswordField(
                              inputController: confirmPasswordController),
                          const SizedBox(height: 30),
                          SignUpButton(
                            onPressed: () {
                              //Validate returns true if the form is valid, or false
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  email = emailController.text;
                                  password = passwordController.text;
                                  confirmPassword =
                                      confirmPasswordController.text;
                                  name = nameController.text;
                                  phoneNumber = phoneNumberController.text;
                                  uploadImage();
                                  addUserToFirebase();
                                  // addUserToFirestore();
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 10),
                          ResetButton(onPressed: () => {clearText()}),
                          const SizedBox(height: 30),
                          const AlreadyMember(),
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
