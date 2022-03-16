import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

getData() async {
  String userId = (FirebaseAuth.instance.currentUser!).uid;
  return FirebaseFirestore.instance.collection('user').doc(userId);
}
