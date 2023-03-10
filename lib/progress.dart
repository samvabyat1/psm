// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:psm/payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  dynamic nf = LoadingIndicator(
    indicatorType: Indicator.lineScalePulseOutRapid,
    colors: const [Colors.green],
    strokeWidth: 2,
  );

  var t = 'Processing your payment...';

  Future<void> initiatethis() async {
    final prefs = await SharedPreferences.getInstance();
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    final DateFormat f = DateFormat('yyyy|MM|dd|HH|mm|ss');
    final String s = f.format(DateTime.now());

    //SENDER SIDE

    final snapshot1 =
        await ref.child(prefs.getString('phone').toString()).child('bal').get();
    int sb = int.parse(snapshot1.value.toString());

    ref
        .child(prefs.getString('phone').toString())
        .child('bal')
        .set(sb - Payment.send);

    ref
        .child(prefs.getString('phone').toString())
        .child('trans')
        .child('$s')
        .set('${Payment.man['phone']}#-#${Payment.send}');

    //50% CASHBACK

    if (Payment.send % 2 == 0 && Payment.send >= 50) {
      ref
          .child(prefs.getString('phone').toString())
          .child('bal')
          .set(sb + (Payment.send) ~/ 2);

      ref
          .child(prefs.getString('phone').toString())
          .child('trans')
          .child('$s' + '0')
          .set('Cashback 50%#+#${(Payment.send) ~/ 2}');

      final snapshots = await ref
          .child(prefs.getString('phone').toString())
          .child('ncount')
          .get();
      int sc = int.parse(snapshots.value.toString());

      ref
          .child(prefs.getString('phone').toString())
          .child('ncount')
          .set(sc + 1);
    }

    //RECIEVER SIDE

    final snapshot = await ref.child(Payment.man['phone']).child('bal').get();
    int rb = int.parse(snapshot.value.toString());

    ref.child(Payment.man['phone']).child('bal').set(rb + Payment.send);

    ref
        .child(Payment.man['phone'])
        .child('trans')
        .child('$s')
        .set('${prefs.getString('phone')}#+#${Payment.send}');

    final snapshotn =
        await ref.child(Payment.man['phone']).child('ncount').get();
    int nc = int.parse(snapshotn.value.toString());

    ref.child(Payment.man['phone']).child('ncount').set(nc + 1);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiatethis();

    Timer(
      const Duration(milliseconds: 3000),
      () {
        setState(() {
          nf = Icon(
            Icons.verified_rounded,
            size: 55,
            color: Colors.green,
          );

          t = 'Payment successful';
        });

        final player = AudioCache();
        player.play('paytm_payment_tune.mp3');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Center(
                child: Container(
              height: 8,
              width: 70,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10)),
            )),
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    t,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'To ${Payment.man['name']}',
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    '₹ ${Payment.send}',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(height: 50, child: nf),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
