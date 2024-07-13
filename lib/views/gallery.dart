// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feathers_gallery/views/captureImage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  String image = '';
  String address = '';
  String species = '';
  Timestamp? date;
  String dropdownvalue1 = 'My';
  var newdate;

  final firebaseUser = FirebaseAuth.instance.currentUser!;
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
                    'Gallery',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                ),
              ),
              // _search(),
              SizedBox(
                height: 25.0,
              ),
              addImage(),
              getInfo()
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {},
      //   tooltip: "Pick Image",
      //   label: const Icon(
      //     Icons.add,
      //     color: Colors.black,
      //   ),
      //   backgroundColor: Colors.yellow,
      // ),
    );
  }

  _search() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextField(
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10.0),
            prefixIcon: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Container(
                height: 40,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(10.0),
                    )),
                child: const Icon(
                  Icons.search,
                ),
              ),
            ),
            hintText: 'Search',
            hintStyle: const TextStyle(color: Colors.white),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.black12),
      ),
    );
  }

  // _dropDownMenu() {
  //   return Container(
  //       width: MediaQuery.of(context).size.width / 2.3,
  //       decoration: BoxDecoration(
  //           color: Colors.deepPurple[500],
  //           borderRadius: BorderRadius.circular(12)),
  //       child: Center(
  //         child: DropdownButton(
  //           // Initial Value
  //           value: dropdownvalue1,
  //           dropdownColor: Colors.black,
  //           icon: const Icon(Icons.keyboard_arrow_down),

  //           // Array list of items
  //           items: items1.map((String items) {
  //             return DropdownMenuItem(
  //               value: items,
  //               child: Center(
  //                   child: Text(
  //                 items,
  //                 style: const TextStyle(
  //                     color: Colors.white, fontWeight: FontWeight.bold),
  //               )),
  //             );
  //           }).toList(),
  //           // After selecting the desired option,it will
  //           // change button value to selected value
  //           onChanged: (String? newValue) {
  //             setState(() {
  //               dropdownvalue1 = newValue!;
  //             });
  //           },
  //         ),
  //       ));
  // }

  addImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: MediaQuery.of(context).size.width / 4,
              decoration: BoxDecoration(
                  color: Colors.deepPurple[500],
                  borderRadius: BorderRadius.circular(25)),
              child: Center(
                  child: TextButton(
                onPressed: (() {}),
                child: const Text(
                  'All',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ))),
        ],
      ),
    );
  }

  horizonBar({required String name}) {
    return Container(
        width: MediaQuery.of(context).size.width / 4,
        decoration: BoxDecoration(
            color: Colors.white54, borderRadius: BorderRadius.circular(25)),
        child: Center(
            child: TextButton(
          onPressed: (() {}),
          child: Text(
            name,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )));
  }

  getInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('data')
            .where("uid", isEqualTo: firebaseUser.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return !snapshot.hasData
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: const EdgeInsets.all(4),
                  child: GridView.count(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      children: snapshot.data!.docs.map((e) {
                        var docId = e.id;
                        return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: FlatButton(
                                onPressed: () {
                                  _onButtonPressed(id: docId);
                                },
                                child: Image.network(e['image'])));
                      }).toList()),
                );
        },
      ),
    );
  }

  // selectData() {
  //   if (dropdownvalue1 == 'My') {
  //     return FirebaseFirestore.instance
  //         .collection('data')
  //         .where("uid", isEqualTo: firebaseUser.uid)
  //         .snapshots();
  //   } else {
  //     return FirebaseFirestore.instance.collection('data').snapshots();
  //   }
  // }

  _onButtonPressed({required String id}) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 450,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text(
                      'Gallery Image',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("data")
                        .doc(id)
                        .get()
                      ..then((ds) {
                        image = ds.get('image');
                        species = ds.get('species');
                        address = ds.get('address');
                        date = ds.get('date');
                      }),
                    builder: (context, AsyncSnapshot snapshot) {
                      return !snapshot.hasData
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(12)),
                              width: MediaQuery.of(context).size.width / 3,
                              height: MediaQuery.of(context).size.height / 2.5,
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                children: [
                                  Image.network(
                                    image,
                                    width: 150,
                                    height: MediaQuery.of(context).size.height /
                                        2.5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, left: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Species :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        ),
                                        Text(
                                          species,
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        const Text(
                                          'Location :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        ),
                                        SizedBox(
                                            width: 200, child: Text(address)),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        const Text(
                                          'Date & Time :',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        ),
                                        Text(date!.toDate().toString()),
                                        SizedBox(
                                          height: 40.0,
                                        ),
                                        // Container(
                                        //     decoration: BoxDecoration(
                                        //         color: Colors.red.shade900,
                                        //         borderRadius:
                                        //             BorderRadius.circular(15)),
                                        //     child: Center(
                                        //         child: TextButton(
                                        //             onPressed: (() {}),
                                        //             child: Icon(
                                        //               Icons.delete,
                                        //               color: Colors.white,
                                        //             )))),
                                      ],
                                    ),
                                  )
                                ],
                              ));
                    },
                  ),
                )
              ],
            ),
          );
        });
  }
}
