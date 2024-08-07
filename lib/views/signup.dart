import 'package:feathers_gallery/services/userdetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String fname = '';
  String lname = '';
  String email = '';
  String password = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue.shade50, Colors.blue.shade200])),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Signup',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 50, 30, 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                    ),
                    onChanged: (value) => setState(() {
                      fname = value;
                    }),
                    validator: Validators.compose([
                      Validators.required('First Name is required'),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 50, 30, 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                    ),
                    onChanged: (value) => setState(() {
                      lname = value;
                    }),
                    validator: Validators.compose([
                      Validators.required('Last Name is required'),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 50, 30, 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'E mail',
                    ),
                    onChanged: (value) => setState(() {
                      email = value;
                    }),
                    validator: Validators.compose([
                      Validators.required('email is required'),
                      Validators.email('invalid email address')
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                  child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    onChanged: (value) => setState(() {
                      password = value;
                    }),
                    validator: Validators.compose(
                        [Validators.required('password is required')]),
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.deepPurple.shade900,
                        borderRadius: BorderRadius.circular(20)),
                    child: TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password)
                              .then((signedInUser) {
                            UserManagement(fname: fname, lname: lname)
                                .storeNewUser(signedInUser.user, context);
                          }).catchError((e) {
                            print(e);
                          });
                        }
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
