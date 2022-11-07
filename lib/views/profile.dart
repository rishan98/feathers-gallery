import 'package:cloud_firestore/cloud_firestore.dart';
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
                                            Container(
                                              height: 40,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  color: Colors.amber,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: TextButton(
                                                onPressed: () async {
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             const HomePage()));
                                                },
                                                child: const Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
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
              Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "No. of Cases",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            FutureBuilder(
                                future: totalUnits(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState !=
                                      ConnectionState.done) {
                                    return const Text('Loading');
                                  }

                                  return Container(
                                    height: 60,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Center(
                                        child: Text(
                                      total,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  );
                                }),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 50, bottom: 20),
                          child: Text(
                            'Cases Dates',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('data')
                              .where("uid", isEqualTo: firebaseUser.uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            return !snapshot.hasData
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: snapshot.data!.docs.map((e) {
                                          Timestamp t = e['date'] as Timestamp;
                                          DateTime date = t.toDate();
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15),
                                            child: Text(
                                              '${date.year} - ${date.month} - ${date.day}',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            ),
                                          );
                                        }).toList()),
                                  );
                          },
                        ),
                      ],
                    ),
                  )),
              
              Container(
                child: SfCircularChart(
                  series: <CircularSeries>[
                            // Render pie chart
                            PieSeries<ChartData, String>(
                                dataSource: chartData,
                                pointColorMapper:(ChartData data,  _) => data.color,
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y
                            )
                        ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final List<ChartData> chartData = [
            ChartData('David', 25, Colors.black),
            ChartData('Steve', 38, Colors.red),
            ChartData('Jack', 34, Colors.amber),
            ChartData('Others', 52, Colors.lightBlue)
        ];
  
}

 class ChartData {
        ChartData(this.x, this.y, this.color);
        final String x;
        final double y;
        final Color color;
    }