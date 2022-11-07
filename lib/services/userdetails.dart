import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feathers_gallery/views/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserManagement {
  final String fname;
  final String lname;

  const UserManagement({
    Key? key,
    required this.fname,
    required this.lname,
  });

  storeNewUser(user, context) {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .set({
          'uid': user.uid,
          'email': user.email,
          'fname': fname,
          'lname': lname
        })
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage())))
        .catchError((e) {
          print(e);
        });
  }
}
