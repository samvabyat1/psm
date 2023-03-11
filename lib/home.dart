// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:psm/landing.dart';
import 'package:psm/notifications.dart';
import 'package:psm/payment.dart';
import 'package:psm/settings.dart';
import 'package:psm/transactions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static var people = [
    {'name': 'Man', 'phone': '1234'}
  ];

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var username = 'User';
  var balance = 0;
  IconData nicon = Icons.notifications_rounded;
  Color? ncolor = Colors.greenAccent[700];
  var promos = ['https://i.postimg.cc/MG5dW9D5/pays-loader.jpg'];

  Future<void> initiatehome() async {
    final prefs = await SharedPreferences.getInstance();

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child(prefs.getString('phone').toString());

    DatabaseReference refpre = FirebaseDatabase.instance.ref();
    refpre.onValue.listen((event) {
      setState(() {
        if (Home.people.length == 1) {
          for (final child in event.snapshot.children) {
            Home.people.insert(0, {
              'name': child.child('name').value.toString(),
              'phone': child.child('phone').value.toString()
            });
          }
        }
        for (final child in event.snapshot.child('promos').children) {
          promos.insert(0, child.value.toString());
        }
      });
    });

    ref.onValue.listen((event) {
      if (mounted) {
        setState(() {
          username = '${event.snapshot.child('name').value} ';
          username = username.substring(0, username.indexOf(' '));
          balance = int.parse(event.snapshot.child('bal').value.toString());

          nicon =
              (int.parse(event.snapshot.child('ncount').value.toString()) > 0)
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_rounded;
          ncolor =
              (int.parse(event.snapshot.child('ncount').value.toString()) > 0)
                  ? Colors.redAccent[700]
                  : Colors.greenAccent[700];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initiatehome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            height: 50,
                            child: Image.asset('assets/images/psm-logo.png')),
                        IconButton(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Notifications(),
                                )),
                            color: ncolor,
                            iconSize: 30,
                            icon: Icon(nicon))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$username,',
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              'Your available balance',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        Text(
                          '₹ $balance',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.greenAccent[700],
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            HI1(
                                ico: Icons.send_to_mobile_rounded,
                                func: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Landing(),
                                      ));
                                },
                                tip: 'Send to mobile'),
                            HI1(
                                ico: Icons.search_rounded,
                                func: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Landing(),
                                      ));
                                },
                                tip: 'Search'),
                            HI1(
                                ico: Icons.history_rounded,
                                func: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Transactions(),
                                      ));
                                },
                                tip: 'History'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Primary',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        HI2(
                            ico: Icons.people_rounded,
                            func: () {},
                            tip: 'People'),
                        HI2(
                            ico: Icons.person_rounded,
                            func: () {},
                            tip: 'Contacts'),
                        HI2(ico: Icons.favorite, func: () {}, tip: 'Favourite'),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        HI2(
                            ico: Icons.bar_chart_rounded,
                            func: () {},
                            tip: 'Invest'),
                        HI2(
                            ico: Icons.credit_card_rounded,
                            func: () {},
                            tip: 'Credit Score'),
                        HI2(
                            ico: Icons.settings_rounded,
                            func: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Settings(),
                                  ));
                            },
                            tip: 'Settings'),
                      ],
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'People',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    //PEOPLE DISPLAY
                    SizedBox(
                        height: (Home.people.length > 5) ? 200 : 100,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      (Home.people.length > 5) ? 2 : 1),
                          itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Payment(
                                              person: Home.people[index],
                                            )));
                              },
                              child: HP(
                                  name: Home.people[index]['name'].toString())),
                          itemCount: Home.people.length - 1,
                        )),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Featured',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(aspectRatio: 2 / 1),
              items: promos.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        i,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.yellowAccent.shade700,
                              Colors.yellow.shade300,
                            ],
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 30,
                            ),
                            Text(
                              'Rewards',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.redAccent.shade700,
                              Colors.red.shade300,
                            ],
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.card_giftcard_rounded,
                              size: 30,
                            ),
                            Text(
                              'Offers',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.blueAccent.shade700,
                              Colors.blue.shade300,
                            ],
                          )),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.people_alt_rounded,
                              size: 30,
                            ),
                            Text(
                              'Referals',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Transactions(),
                            ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.history_rounded),
                          Text(
                            '  Transaction history',
                          ),
                        ],
                      ))
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Colors.green[100],
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your payments are totally secured',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HP extends StatelessWidget {
  final String name;
  HP({super.key, required this.name});
  var c = [
    Colors.deepPurple,
    Colors.purple[900],
    Colors.blue[900],
    Colors.indigo[900],
    Colors.green[900],
    Colors.yellow[900],
    Colors.deepOrange,
    Colors.red[900],
    Colors.redAccent[700],
    Colors.greenAccent[700],
    Colors.blueAccent[700],
    Colors.orangeAccent[700],
    Colors.yellowAccent[700],
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        child: Column(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: c[Random().nextInt(c.length)],
                  borderRadius: BorderRadius.circular(25)),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    name[0],
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
            Text(
              name,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class HI2 extends StatelessWidget {
  final func;
  final IconData ico;
  final String tip;
  const HI2(
      {super.key, required this.ico, required this.func, required this.tip});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: func,
      icon: Icon(ico),
      iconSize: 30,
      tooltip: tip,
    );
  }
}

class HI1 extends StatelessWidget {
  final func;
  final IconData ico;
  final String tip;
  const HI1(
      {super.key, required this.ico, required this.func, required this.tip});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: func,
      icon: Icon(ico),
      iconSize: 30,
      color: Colors.white,
      tooltip: tip,
    );
  }
}
