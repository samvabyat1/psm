// ignore_for_file: prefer_const_constructors, unused_local_variable, use_build_context_synchronously

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:psm/pin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  var name = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 100,
                    child: Image.asset('assets/images/psm-logo.png')),
                Text(
                  'Fill details',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Help us to know about your identity.',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 55,
                  child: TextField(
                    keyboardType: TextInputType.name,
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: InputDecoration(
                        hintText: 'Name',
                        prefixIcon: Icon(Icons.person_rounded,
                            color: Colors.greenAccent[700]),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.greenAccent.shade700, width: 3)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.greenAccent.shade700, width: 3))),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 55,
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                        hintText: '+91 9876543210',
                        prefixIcon: Icon(Icons.phone_rounded,
                            color: Colors.green.shade200),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.green.shade200, width: 3))),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();

                        DatabaseReference ref = FirebaseDatabase.instance
                            .ref()
                            .child(prefs.getString('phone').toString());

                        if (name == null) {
                          Fluttertoast.showToast(msg: 'Please enter your name');
                        } else {
                          ref.child('name').set(name.trim());
                          ref
                              .child('phone')
                              .set(prefs.getString('phone').toString());
                          ref.onValue.listen((event) {
                            if (event.snapshot.child('bal').value == null) {
                              //FIRST TIME ACC OPEN
                              // WELCOME REWARD ₹100

                              final DateFormat f =
                                  DateFormat('yyyy|MM|dd|HH|mm|ss');
                              final String s = f.format(DateTime.now());

                              ref
                                  .child('trans')
                                  .child('$s')
                                  .set('Welcome Reward#+#100');

                              ref.child('bal').set(100);

                              ref.child('ncount').set(1);
                            }
                          });

                          await prefs.setString('name', name);
                          await prefs.setInt('counter', 2);

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Pin(end: false),
                              ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          // backgroundColor: Color(0xff058C42),
                          backgroundColor: Colors.greenAccent[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
