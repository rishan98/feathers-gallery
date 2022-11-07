import 'dart:io';

import 'package:feathers_gallery/views/captureImage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  File? _image;
  late List _results;
  bool imageSelect = false;
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    String res;
    res = (await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/labels.txt"))!;
    print("Models loading status: $res");
  }

  Future imageClassification(File image) async {
    final List? recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 4,
      threshold: 0.6,
      imageMean: 255.5,
      imageStd: 255.5,
    );
    setState(() {
      _results = recognitions!;
      _image = image;
      imageSelect = true;
    });
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
                    'Scan Feather',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: _image != null
                    ? Image.file(
                        _image!,
                        width: 250,
                        height: 250,
                      )
                    : Column(
                        children: [
                          Image.asset(
                            'assets/images/scan.png',
                            height: 200,
                            width: 200,
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            'No image selected',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: (imageSelect)
                      ? _results.map((result) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Bird - ${result['label']}",
                                        style: const TextStyle(
                                            color: Colors.red, fontSize: 20),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "Accuracy - ${result['confidence'].toStringAsFixed(2)}",
                                        style: const TextStyle(
                                            color: Colors.green, fontSize: 17),
                                      ),
                                      const SizedBox(
                                        height: 50.0,
                                      ),
                                      Center(
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.deepPurple.shade800,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Center(
                                                child: TextButton(
                                              onPressed: (() {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CaptureImage(
                                                                image: _image,
                                                                name:
                                                                    "${result['label']}")));
                                              }),
                                              child: const Text(
                                                'Add to App Galley',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ))),
                                      ),
                                      SizedBox(
                                        height: 10.0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList()
                      : [],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: pickImage,
        tooltip: "Pick Image",
        label: const Text('Select Image'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    File image = File(pickedFile!.path);
    imageClassification(image);
  }
}
