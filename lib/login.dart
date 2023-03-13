// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'details.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  static String verify = '';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var phone = '';

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
                  'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Use your phone number to authenticate.',
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
                    onChanged: (value) {
                      phone = value;
                    },
                    keyboardType: TextInputType.phone,
                    // inputFormatters: <TextInputFormatter>[
                    //   FilteringTextInputFormatter.digitsOnly
                    // ],
                    decoration: InputDecoration(
                        hintText: 'Phone',
                        prefixText: '+91  ',
                        prefixIcon: Icon(Icons.phone_rounded,
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
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (phone.length == 10) {
                          Fluttertoast.showToast(
                              msg: 'You will be redirected to your browser');
                          await FirebaseAuth.instance.verifyPhoneNumber(
                            phoneNumber: '+91$phone',
                            verificationCompleted:
                                (PhoneAuthCredential credential) {},
                            verificationFailed: (FirebaseAuthException e) {},
                            codeSent: (String verificationId,
                                int? resendToken) async {
                              Login.verify = verificationId;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Otp(),
                                  ));
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString('phone', phone);
                            },
                            codeAutoRetrievalTimeout:
                                (String verificationId) {},
                          );
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Your phone number seems to be incorrect');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          // backgroundColor: Color(0xff058C42),
                          backgroundColor: Colors.greenAccent[700],
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

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  late TextEditingController textEditingController1;

  String _comingSms = 'Unknown';

  Future<void> initSmsListener() async {
    String? comingSms;
    try {
      comingSms = await AltSmsAutofill().listenForSms;
    } on PlatformException {
      comingSms = 'Failed to get Sms.';
    }
    if (!mounted) return;
    setState(() {
      _comingSms = comingSms!;
      Fluttertoast.showToast(msg: 'Auto fetching OTP');
      print("====>Message: ${_comingSms}");
      print("${_comingSms[32]}");
      textEditingController1.text = _comingSms[0] +
          _comingSms[1] +
          _comingSms[2] +
          _comingSms[3] +
          _comingSms[4] +
          _comingSms[
              5]; //used to set the code in the message to a string and setting it to a textcontroller. message length is 38. so my code is in string index 32-37.
    });
  }

  @override
  void initState() {
    super.initState();
    textEditingController1 = TextEditingController();
    initSmsListener();
  }

  @override
  void dispose() {
    textEditingController1.dispose();
    AltSmsAutofill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    // var code = '';

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
                  'Verify phone',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  'Enter the otp sent to your number.',
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
                  child: Pinput(
                    controller: textEditingController1,
                    // onChanged: (value) {
                    //   code = value;
                    // },
                    length: 6,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
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
                      int errorflag = 0;

                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: Login.verify,
                                smsCode: textEditingController1.text);

                        await FirebaseAuth.instance
                            .signInWithCredential(credential);
                      } catch (e) {
                        Fluttertoast.showToast(msg: 'Incorrect otp');
                        setState(() {
                          errorflag = 1;
                        });
                      } 
                      
                      if(errorflag == 0) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setInt('counter', 1);
                        // Sign the user in (or link) with the credential
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Details(),
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
                      'VERIFY',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.lightGreen[800],
                      size: 18,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ));
                        },
                        child: Text(
                          'Edit phone number',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightGreen[800],
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
