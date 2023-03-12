// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psm/payment.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class QR extends StatefulWidget {
  const QR({super.key});

  @override
  State<QR> createState() => _QRState();
}

class _QRState extends State<QR> {
  String phone = '';

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  Future<void> initqr() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      phone = prefs.getString('phone').toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initqr();
  }

  @override
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );

    return Scaffold(
      body: SlidingUpPanel(
        panel: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: QrImage(
              data: phone,
              version: QrVersions.auto,
              size: 320,
              gapless: false,
            ),
          ),
        ),
        collapsed: Container(
          decoration: BoxDecoration(color: Colors.green, borderRadius: radius),
          child: Center(
            child: Text(
              "My QR Code",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
        ),
        borderRadius: radius,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });

      if (scanData.code?.length == 10) {
        DatabaseReference ref =
            FirebaseDatabase.instance.ref().child(scanData.code.toString());

        final snapshot = await ref.child('name').get();
        String name = snapshot.value.toString();

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Payment(
                  person: {'name': name, 'phone': scanData.code.toString()}),
            ));
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
