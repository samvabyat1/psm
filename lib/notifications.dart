// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psm/payment.dart';
import 'package:psm/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  var title = [''];
  var sub = [''];
  Future<void> initnotif() async {
    final prefs = await SharedPreferences.getInstance();

    final refRE = FirebaseDatabase.instance
        .ref()
        .child(prefs.getString('phone').toString())
        .child('trans')
        .orderByKey();

    refRE.onValue.listen((event) {
      if (mounted) {
        setState(() {
          for (final child in event.snapshot.children) {
            if (child.value.toString().split('#')[1] == '+') {
              title.insert(0, child.value.toString().split('#')[2]);
              sub.insert(0, child.value.toString().split('#')[0]);
            }
          }
        });
      }
    });

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child(prefs.getString('phone').toString());

    final snapshotn = await ref.child('ncount').get();
    int nc = int.parse(snapshotn.value.toString());

    ref.child('ncount').set(0);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initnotif();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Settings(),
                            )),
                        color: Colors.white,
                        iconSize: 25,
                        icon: Icon(Icons.settings_rounded)),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: title.length - 1,
                  itemBuilder: (context, index) =>
                      NC(title: title[index], sub: sub[index]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NC extends StatelessWidget {
  final String title;
  final String sub;
  const NC({super.key, required this.title, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '₹$title recieved',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
              Text(
                'From $sub',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
