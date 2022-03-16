// ignore_for_file: deprecated_member_use, prefer_const_constructors
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukk/constants/color_constant.dart';

class AddNewCollection extends StatefulWidget {
  const AddNewCollection({Key? key}) : super(key: key);

  @override
  State<AddNewCollection> createState() => _AddNewCollectionState();
}

class _AddNewCollectionState extends State<AddNewCollection> {
  File? _image;
  final _picker = ImagePicker();
  String url = "";
  //Editing Controllers
  final collectionNameController = TextEditingController();

  Future getImageFromGallery() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    final File image = File(pickedFile!.path);
    setState(() {
      _image = image;
    });
  }

  uploadCollection() async {
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
  Widget build(BuildContext context) {
    final fileName =
        _image != null ? basename(_image!.path) : 'No Image Selected';

    final addNewCollection = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: kGreenColor,
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
              padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () {
                uploadCollection();
                // Adding the name of the collection and the image to the Firebase storage and firestore,
                // then navigating to the collection_page.dart,
                // and also displaying the result on colletion_page.dart
                // with the shape of a card from card_collection.dart
              },
            ),
          ),
        ),
      ),
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "New Collection",
            style: GoogleFonts.dongle(
              fontSize: 40,
              color: kWhiteColor,
            ),
          ),
          backgroundColor: kDarkBlue,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: kWhiteColor,
            ),
            onPressed: () {
              //passing this to our root
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Form(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/backgrounds%2Fgradienta-7brhZmwXn08-unsplash.jpg?alt=media&token=ea7ee065-0bb3-4184-8baf-9188d268f075"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
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
                            SizedBox(height: 5),
                            Text(
                              fileName,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 40),
                            Text(
                              'Collection Name',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextField(
                              autofocus: false,
                              controller: collectionNameController,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 15, 20, 15),
                                hintText: "Example: My Hotwheels",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            addNewCollection,
                          ],
                        ),
                      ),
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
