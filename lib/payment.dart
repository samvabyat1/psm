// ignore_for_file: prefer_const_constructors

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:psm/pin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Payment extends StatefulWidget {
  final Map<String, String> person;
  const Payment({super.key, required this.person});

  static var man;
  static int send = 0;

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  var amt = '';
  int sb = 0;

  Future<void> getbal() async {
    final prefs = await SharedPreferences.getInstance();
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot1 =
        await ref.child(prefs.getString('phone').toString()).child('bal').get();
    setState(() {
  sb =  int.parse(snapshot1.value.toString());
});
  }

  @override
  void initState() {
    // TODO: implement initState
    Payment.man = widget.person;
    super.initState();
    getbal();
  }

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
                // SizedBox(
                //     height: 100,
                //     child: Image.asset('assets/images/psm-logo.png')),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.green[900],
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.person['name'].toString()[0],
                        style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  widget.person['name'].toString(),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  widget.person['phone'].toString(),
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 55,
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      amt = value;
                    },
                    keyboardType: TextInputType.phone,
                    // inputFormatters: <TextInputFormatter>[
                    //   FilteringTextInputFormatter.digitsOnly
                    // ],
                    decoration: InputDecoration(
                        hintText: 'Amount',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.black, width: 3)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: Colors.green.shade900, width: 3))),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                      onPressed: () {
                        if (amt.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Amount should not be empty');
                        } else {
                          Payment.send = int.parse(amt);
                          if (Payment.send > sb ) {
                            Fluttertoast.showToast(
                                msg: 'Seems that your balance is insufficient');
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Pin(end: true),
                              ));}
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          // backgroundColor: Color(0xff058C42),
                          backgroundColor: Colors.green[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      child: Text(
                        'NEXT',
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
