import 'dart:io';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feathers_gallery/views/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class CaptureImage extends StatefulWidget {
  final dynamic image;
  final String name;

  const CaptureImage({Key? key, required this.image, required this.name})
      : super(key: key);

  @override
  State<CaptureImage> createState() => _CaptureImageState();
}

class _CaptureImageState extends State<CaptureImage> {
  var date = DateTime.now();
  late Position position;
  String Address = '';

  Future getPosition() async {
    Position currentPosition =
        await GeolocatorPlatform.instance.getCurrentPosition();
    setState(() async {
      position = currentPosition;
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      // print(placemarks);
      print(position.latitude);
      Placemark place = placemarks[0];
      Address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
      print(Address);
      // final coordinate =
      //     new geoCo.Coordinates(position.latitude, position.longitude);
      // var address =
      //     await geoCo.Geocoder.local.findAddressesFromCoordinates(coordinate);
      // firstAddress = address.first.addressLine.toString();
    });
  }

  // get() {
  //   print(position.latitude);
  // }

  @override
  void initState() {
    getPosition();
    super.initState();
  }

  String url = '';

  Future uploadImage() async {
    String name = DateTime.now().millisecondsSinceEpoch.toString();
    var imageFile =
        FirebaseStorage.instance.ref().child('feathers').child(name);
    UploadTask task = imageFile.putFile(widget.image!);
    TaskSnapshot snapshot = await task;

    url = await snapshot.ref.getDownloadURL();

    final firebaseUser = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection('data').add({
      "uid": firebaseUser.uid,
      "date": date,
      "image": url.toString(),
      "lat": position.latitude.toString(),
      "lon": position.longitude.toString(),
      "address": Address,
      "species": widget.name
    });

    // setState(() {
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => MapPage(
    //               url: url.toString(),
    //               radio1: _value1,
    //               radio2: _value2,
    //               place: place.text)));
    // });
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
                    'Capture Image',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.file(
                    widget.image!,
                    width: 400,
                    height: 400,
                  )),
              Center(
                  child: Text(
                widget.name,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              )),
              const SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          uploadImage();
          _buildErrorMessage("Image added successfully.");
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        },
        tooltip: "Pick Image",
        label: const Text('Save'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _buildErrorMessage(String text) {
    Fluttertoast.showToast(
        msg: text,
        timeInSecForIosWeb: 5,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[600],
        textColor: Colors.white,
        fontSize: 14);
  }
}
