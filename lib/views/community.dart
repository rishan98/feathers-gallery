import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import 'homePage.dart';

class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  String desc = '';

  name() async {
    final firebaseUser = FirebaseAuth.instance.currentUser!;
    DocumentSnapshot uname = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .get();

    print(uname['fname']);

    FirebaseFirestore.instance
        .collection('posts')
        .doc()
        .set({'fname': uname['fname'], 'desc': desc})
        .then((value) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomePage())))
        .catchError((e) {
          print(e);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'First Name',
            ),
            onChanged: (value) => setState(() {
              desc = value;
            }),
            validator: Validators.compose([
              Validators.required('First Name is required'),
            ]),
          ),
          TextButton(
            onPressed: () {
              name();
            },
            child: Text('click'),
          ),
        ],
      )),
    );
  }
}
