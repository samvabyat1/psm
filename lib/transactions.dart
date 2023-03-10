// ignore_for_file: prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psm/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  var textlist = [''];
  var dtlist = [''];

  Future<void> inittrans() async {
    final prefs = await SharedPreferences.getInstance();

    final ref = FirebaseDatabase.instance
        .ref()
        .child(prefs.getString('phone').toString())
        .child('trans')
        .orderByKey();

    ref.onValue.listen((event) {
      if (mounted) {
        setState(() {
          for (final child in event.snapshot.children) {
            textlist.insert(0, child.value.toString());
            dtlist.insert(0, child.key.toString());
          }
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inittrans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Transactions',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Settings(),
                            )),
                        iconSize: 25,
                        icon: Icon(Icons.settings_rounded)),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  color: Colors.grey,
                  height: 1,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: textlist.length - 1,
                  itemBuilder: (context, index) =>
                      TC(text: textlist[index], dt: dtlist[index]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TC extends StatelessWidget {
  final String dt;
  final String text;
  const TC({super.key, required this.text, required this.dt});

  @override
  Widget build(BuildContext context) {
    var s = text.split('#');
    var d = dt.split('|');
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            child: Column(
              children: [
                Text(
                  d[2] +
                      '/' +
                      d[1] +
                      '/' +
                      d[0] +
                      ' ' +
                      d[3] +
                      ':' +
                      d[4] +
                      ':' +
                      d[5],
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      s[0],
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      s[1] + s[2],
                      style: TextStyle(
                          color: (s[1] == '+') ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          color: Colors.grey,
          height: 1,
        )
      ],
    );
  }
}
