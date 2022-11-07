import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

class GoogleMAp extends StatefulWidget {
  const GoogleMAp({Key? key}) : super(key: key);

  @override
  State<GoogleMAp> createState() => _GoogleMApState();
}

class _GoogleMApState extends State<GoogleMAp> {
  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  final firebaseUser = FirebaseAuth.instance.currentUser!;
  late BitmapDescriptor icon;

  @override
  void initState() {
    getIcon();
    super.initState();
  }

  getIcon() async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/seagull.png', 150);
    var icon = BitmapDescriptor.fromBytes(markerIcon);
    // var icon = await BitmapDescriptor.fromAssetImage(
    //     const ImageConfiguration(size: Size(5, 5)),
    //     "assets/images/seagull.png");
    setState(() {
      this.icon = icon;
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('data')
                .where("uid", isEqualTo: firebaseUser.uid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Text('loading');
              }
              if (snapshot.hasData) {
                for (var element in snapshot.data!.docs) {
                  var mar = element.id;
                  final MarkerId markerId = MarkerId(mar);

                  _markers[markerId] = Marker(
                      icon: icon,
                      markerId: markerId,
                      position: LatLng(
                        double.parse(element['lat']),
                        double.parse(element['lon']),
                      ),
                      infoWindow: InfoWindow(title: element['species']));
                }

                return GoogleMap(
                  compassEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    controller = controller;
                  },
                  initialCameraPosition: const CameraPosition(
                      target: LatLng(7.1725, 79.8853), zoom: 9.0),
                  mapType: MapType.normal,
                  markers: Set<Marker>.of(_markers.values),
                );
              }
              return const Text("loading");
            }),
      ],
    );
  }
}
