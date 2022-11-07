import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final dynamic icon;
  final String iconName;
  final Widget page;

  FeatureCard(
      {Key? key,
      required this.icon,
      required this.iconName,
      required this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width / 2.2,
      decoration: BoxDecoration(
          color: Colors.white70, borderRadius: BorderRadius.circular(20)),
      child: TextButton(
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                image:
                    DecorationImage(image: AssetImage(icon), fit: BoxFit.fill),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              iconName,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
