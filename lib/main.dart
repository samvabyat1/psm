import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:psm/login.dart';
import 'package:psm/pin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

import 'details.dart';
import 'home.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  WidgetsFlutterBinding.ensureInitialized();

  Future<Null> initUniLinks()async{
     try{
        Uri? initialLink = await getInitialUri();
        print(initialLink);
     } on PlatformException {
       print('platfrom exception unilink');
     }
   }

   initUniLinks();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      fontFamily: 'Montserrat-Medium',
      primarySwatch: Colors.green,
    ),
    home: Splash(),
  ));
}


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  int? counter;
  Future<void> initiation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = prefs.getInt('counter');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initiation();
    Timer(
      const Duration(milliseconds: 3000),
      () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => (counter == 1)
                ? Details()
                : (counter == 2)
                    ? Pin(end: false,)
                    : (counter == 3)
                        ? Home()
                        : Login(),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset('assets/images/psm-logo.png'),
        ),
      ),
    );
  }
}