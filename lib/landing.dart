// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psm/home.dart';
import 'package:psm/payment.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  var found = [{}];

  @override
  void initState() {
    found = Home.people;
    super.initState();
  }

  void runfilter(String kw) {
    var results = [{}];
    if (kw.isEmpty) {
      results = Home.people;
    } else {
      results = Home.people
          .where((element) =>
              element['name']!.toLowerCase().contains(kw.toLowerCase()) ||
              element['phone']!.contains(kw))
          .toList();
    }

    setState(() {
      found = results;
    });
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
                  children: [
                    Text(
                      'Select user',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 55,
                  child: TextField(
                    onChanged: (value) => runfilter(value),
                    decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon:
                            Icon(Icons.search_rounded, color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.greenAccent.shade700, width: 3)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.amber, width: 3))),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text('Your search results are global',
                    style: TextStyle(color: Colors.amber)),
                SizedBox(
                  height: 25,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: found.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: InkWell(
                      onTap: () => (index != found.length - 1)
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Payment(
                                        person: Home.people[index],
                                      )))
                          : Fluttertoast.showToast(
                              msg: 'User: Man cannot be accessed'),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.amber[50],
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                found[index]['name'].toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                found[index]['phone'].toString(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
