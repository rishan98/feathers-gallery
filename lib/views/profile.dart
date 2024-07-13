import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feathers_gallery/views/appInfo.dart';
import 'package:feathers_gallery/views/gallery.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final firebaseUser = FirebaseAuth.instance.currentUser!;

  late String total = '';

  var thisyear = DateTime.now().year;
  var thismonth = DateTime.now().month;
  getDate() {
    var nextMonth = DateTime(thisyear, thismonth - 2, 0);
    return nextMonth;
  }

  totalUnits() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance
        .collection('data')
        .where('uid', isEqualTo: firebaseUser.uid)
        .get();
    List<DocumentSnapshot> myDocCount = _myDoc.docs;
    total = myDocCount.length.toString();
    return print(total);
  }

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
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.purple.shade800,
                            Colors.deepPurple.shade900
                          ]),
                      borderRadius: BorderRadius.circular(20)),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where("uid", isEqualTo: firebaseUser.uid)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      return !snapshot.hasData
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                  children: snapshot.data!.docs.map((e) {
                                var docId = e.id;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 150,
                                          width: 150,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/man1.png'),
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            e['fname'],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            e['lname'],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          children: [
                                            Text(
                                              e['email'],
                                              style: const TextStyle(
                                                color: Colors.white70,
                                                fontSize: 17,
                                              ),
                                            ),
                                            const Spacer(),
                                            // Container(
                                            //   height: 40,
                                            //   width: 50,
                                            //   decoration: BoxDecoration(
                                            //       color: Colors.amber,
                                            //       borderRadius:
                                            //           BorderRadius.circular(
                                            //               15)),
                                            //   child: TextButton(
                                            //     onPressed: () async {
                                            //       // Navigator.push(
                                            //       //     context,
                                            //       //     MaterialPageRoute(
                                            //       //         builder: (context) =>
                                            //       //             const HomePage()));
                                            //     },
                                            //     child: const Text(
                                            //       'Edit',
                                            //       style: TextStyle(
                                            //           color: Colors.black),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList()),
                            );
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'Settings',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      _settingBar(
                          wid: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          ),
                          name: 'App Info',
                          page: AppInfo()),
                      const SizedBox(
                        height: 10.0,
                      ),
                      _settingBar(
                          wid: const Icon(Icons.notification_add,
                              color: Colors.white),
                          name: 'Images',
                          page: Gallery()),
                      const SizedBox(
                        height: 10.0,
                      ),
                      _settingBar(
                          wid: const Icon(Icons.help, color: Colors.white),
                          name: 'Help',
                          page: AppInfo()),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       FutureBuilder(
              //           future: totalUnits(),
              //           builder: (context, snapshot) {
              //             if (snapshot.connectionState !=
              //                 ConnectionState.done) {
              //               return const Text('Loading');
              //             }

              //             return Container(
              //               height: 100,
              //               width: MediaQuery.of(context).size.width / 2.5,
              //               padding: EdgeInsets.all(15),
              //               decoration: BoxDecoration(
              //                   color: Colors.redAccent,
              //                   borderRadius: BorderRadius.circular(12)),
              //               child: Center(
              //                   child: Column(
              //                 children: [
              //                   Text(
              //                     total,
              //                     style: const TextStyle(
              //                         fontSize: 30,
              //                         fontWeight: FontWeight.bold,
              //                         color: Colors.white),
              //                   ),
              //                   Text(
              //                     'Cases',
              //                     style: const TextStyle(
              //                         fontWeight: FontWeight.bold,
              //                         color: Colors.white),
              //                   )
              //                 ],
              //               )),
              //             );
              //           }),
              //       Container(
              //         height: 100,
              //         width: MediaQuery.of(context).size.width / 2.5,
              //         padding: EdgeInsets.all(15),
              //         decoration: BoxDecoration(
              //             color: Colors.redAccent,
              //             borderRadius: BorderRadius.circular(12)),
              //         child: Center(
              //             child: Column(
              //           children: [
              //             Text(
              //               '2',
              //               style: const TextStyle(
              //                   fontSize: 30,
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.white),
              //             ),
              //             Text(
              //               'Recent',
              //               style: const TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.white),
              //             )
              //           ],
              //         )),
              //       ),
              //     ],
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: FutureBuilder(
                    future: totalUnits(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Text('Loading');
                      }

                      return Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width / 2.5,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12)),
                        child: Center(
                            child: Column(
                          children: [
                            Text(
                              total,
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              'Birds Images',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        )),
                      );
                    }),
              ),
              SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  _settingBar(
      {required Widget wid, required String name, required Widget page}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(25)),
            child: Center(child: TextButton(onPressed: (() {}), child: wid))),
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Center(
                child: TextButton(
                    onPressed: (() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => page));
                    }),
                    child: Icon(Icons.arrow_forward)))),
      ],
    );
  }
}
